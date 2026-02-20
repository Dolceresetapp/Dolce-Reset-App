import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/constants/validation.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/toast.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/networks/api_acess.dart';
import 'package:gritti_app/networks/dio/dio.dart';
import 'package:gritti_app/networks/endpoints.dart';
import 'package:gritti_app/services/preload_service.dart';
import 'package:provider/provider.dart';

import '../../../common_widget/custom_button.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/di.dart';
import '../../../helpers/navigation_service.dart';
import '../../../provider/sign_up_provider.dart';
import '../widgets/logo_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isWeb2WaveMode = false;

  @override
  void initState() {
    super.initState();
    // Start preloading in background as soon as user sees login screen
    preloadService.preloadOnLoginScreen();

    // Pre-fill email if coming from Web2Wave deep link
    final web2waveEmail = appData.read('web2wave_email');
    if (web2waveEmail != null && web2waveEmail.toString().isNotEmpty) {
      _emailController.text = web2waveEmail;
      _isWeb2WaveMode = true;
      // Clear it so it doesn't persist on next visit
      appData.remove('web2wave_email');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handle Web2Wave set-password + auto-login
  Future<void> _redeemWeb2Wave() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xFF000000).withValues(alpha: 0.3),
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Use dedicated Dio instance to avoid shared interceptor/redirect issues
      final dio = Dio(BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        followRedirects: false,
        validateStatus: (status) => status != null && status < 500,
      ));

      log('[SignIn] Calling POST $url${Endpoints.setPassword()}');
      final response = await dio.post(
        Endpoints.setPassword(),
        data: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'password_confirmation': _confirmPasswordController.text.trim(),
          'name': _nameController.text.trim(),
        },
      );

      log('[SignIn] Response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['status'] == true) {
        final token = response.data['token'];
        final data = response.data['data'];

        // Save auth data (same as sign-in RX handler)
        appData.write(kKeyAccessToken, token);
        appData.write(kKeyID, data['id']);
        appData.write(kKeyName, data['name'] ?? '');
        appData.write(kKeyEmail, data['email'] ?? '');
        appData.write(kKeyAvatar, data['avatar'] ?? '');
        // Web2Wave users have already completed onboarding + payment on the web
        appData.write(kKeyUsrInfo, 1);
        appData.write(kKeyPaymentMethod, 1);
        appData.write('payment_source', 'web2wave');
        appData.write(kKeyIsNutration, data['is_nutration'] ?? 0);
        appData.write(kKeyIsLoggedIn, true);

        // Clean up deep link data so it doesn't trigger redeem again
        appData.remove('web2wave_email');
        appData.remove('web2wave_user_id');

        DioSingleton.instance.update(token);

        log('[SignIn] Web2Wave redeem success, navigating to loading...');
        NavigationService.navigateToUntilReplacement(Routes.loadingScreen);
      } else {
        if (mounted) Navigator.of(context).pop(); // Close loading
        final msg = response.data is Map
            ? response.data['message']
            : 'Errore durante la registrazione';
        ToastUtil.showShortToast(msg ?? 'Errore durante la registrazione');
      }
    } on DioException catch (e) {
      if (mounted) Navigator.of(context).pop(); // Close loading
      final data = e.response?.data;
      final serverMessage = data is Map ? data['message'] : null;
      log('[SignIn] Web2Wave redeem error: ${e.response?.statusCode} - $serverMessage');
      ToastUtil.showShortToast(serverMessage ?? 'Errore di connessione. Riprova.');
    } catch (e) {
      if (mounted) Navigator.of(context).pop(); // Close loading
      log('[SignIn] Web2Wave redeem error: $e');
      ToastUtil.showShortToast('Errore di connessione. Riprova.');
    }
  }

  bool ischecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: Form(
            autovalidateMode: AutovalidateMode.onUnfocus,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpace(16.h),
                if (!_isWeb2WaveMode)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 22.w,
                        color: const Color(0xFF27272A),
                      ),
                    ),
                  ),
                UIHelper.verticalSpace(16.h),
                LogoWidget(
                  title: _isWeb2WaveMode
                      ? "Completa la registrazione"
                      : "Accedi al tuo account",
                ),

                if (_isWeb2WaveMode) ...[
                  UIHelper.verticalSpace(16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF0FF),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFF767EFF), width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF767EFF), size: 20.w),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            "Abbonamento acquistato dal sito! Imposta la tua password per accedere.",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                              color: const Color(0xFF3F3F46),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                UIHelper.verticalSpace(_isWeb2WaveMode ? 24.h : 56.h),

                if (_isWeb2WaveMode) ...[
                  Text(
                    "Nome",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  UIHelper.verticalSpace(8.h),
                  CustomTextField(
                    controller: _nameController,
                    validator: nameValidation,
                    hintText: "Inserisci il tuo nome",
                    keyboardType: TextInputType.name,
                    prefixIcon: Assets.icons.vector2,
                  ),
                  UIHelper.verticalSpace(16.h),
                ],

                Text(
                  "Indirizzo Email",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                UIHelper.verticalSpace(8.h),

                CustomTextField(
                  controller: _emailController,
                  validator: emailValidation,
                  hintText: "Inserisci la tua email...",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Assets.icons.vector2,
                  readOnly: _isWeb2WaveMode,
                  filled: _isWeb2WaveMode,
                  fillColor: _isWeb2WaveMode ? const Color(0xFFE4E4E7) : null,
                ),

                UIHelper.verticalSpace(16.h),

                Text(
                  "Password",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                UIHelper.verticalSpace(8.h),

                Consumer<SignupProvider>(
                  builder: (context, provider, child) {
                    return CustomTextField(
                      prefixIcon: Assets.icons.vector3,
                      obscureText: !provider.passwordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        onPressed: provider.togglePasswordVisibility,
                        icon: SvgPicture.asset(
                          provider.passwordVisible
                              ? Assets.icons.eyeOn
                              : Assets.icons.eyeOff,
                          width: 20.w,
                          height: 20.h,
                          fit: BoxFit.none,
                          colorFilter: ColorFilter.mode(
                            Color(0xFFA1A1AA),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      controller: _passwordController,
                      hintText: "Password",
                      validator: passwordValidation,
                    );
                  },
                ),
                if (_isWeb2WaveMode) ...[
                  UIHelper.verticalSpace(12.h),
                  Text(
                    "Conferma Password",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  UIHelper.verticalSpace(8.h),
                  Consumer<SignupProvider>(
                    builder: (context, provider, child) {
                      return CustomTextField(
                        prefixIcon: Assets.icons.vector3,
                        obscureText: !provider.confirmPasswordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _confirmPasswordController,
                        hintText: "Conferma Password",
                        validator: (value) => confirmPasswordValidation(
                          value,
                          _passwordController.text,
                        ),
                        suffixIcon: IconButton(
                          onPressed: provider.toggleConfirmPasswordVisibility,
                          icon: SvgPicture.asset(
                            provider.confirmPasswordVisible
                                ? Assets.icons.eyeOn
                                : Assets.icons.eyeOff,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.none,
                            colorFilter: ColorFilter.mode(
                              Color(0xFFA1A1AA),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],

                if (!_isWeb2WaveMode) ...[
                  UIHelper.verticalSpace(16.h),
                  Row(
                    spacing: 8.w,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          activeColor: Color(0xFF777EFF),
                          value: ischecked,
                          onChanged: (value) {
                            setState(() {
                              ischecked = value!;
                            });
                          },
                        ),
                      ),
                      Text(
                        "Ricordami",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                            .copyWith(
                              color: const Color(0xFF27272A),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          NavigationService.navigateTo(
                            Routes.forgetPasswordScreen,
                          );
                        },
                        child: Text(
                          'Password dimenticata?',
                          textAlign: TextAlign.right,
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: const Color(0xFF767EFF),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],

                UIHelper.verticalSpace(30.h),
                CustomButton(
                  onPressed: () {
                    if (_isWeb2WaveMode) {
                      _redeemWeb2Wave();
                    } else {
                      if (!_formKey.currentState!.validate()) return;
                      signInRxObj
                          .signInRx(
                            email: _emailController.text.trim().toString(),
                            password: _passwordController.text.trim().toString(),
                          )
                          .waitingForFuture()
                          .then((success) {
                            if (success) {
                              NavigationService.navigateToReplacement(
                                Routes.loadingScreen,
                              );
                            }
                          });
                    }
                  },
                  child: Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isWeb2WaveMode ? "Completa e accedi" : "Accedi",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                      ),
                      SvgPicture.asset(
                        Assets.icons.arrowRight,
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),

                // TODO: Réactiver le séparateur "ou" avec Google/Apple sign-in
                // UIHelper.verticalSpace(16.h),
                // SvgPicture.asset(Assets.icons.or, width: 1.sw),
                // UIHelper.verticalSpace(16.h),

                // TODO: Réactiver Google sign-in
                // CustomButton(
                //   color: Color(0xFF000000),
                //   onPressed: () {},
                //   child: Row(
                //     spacing: 10.w,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       SvgPicture.asset(
                //         Assets.icons.vector4,
                //         width: 20.w,
                //         height: 20.h,
                //         fit: BoxFit.cover,
                //       ),
                //       Text(
                //         "Accedi con Google",
                //         style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                //       ),
                //     ],
                //   ),
                // ),

                // TODO: Réactiver Apple sign-in
                // CustomButton(
                //   color: Color(0xFF000000),
                //   onPressed: () {},
                //   child: Row(
                //     spacing: 10.w,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       SvgPicture.asset(
                //         Assets.icons.appleIcon,
                //         width: 20.w,
                //         height: 20.h,
                //         fit: BoxFit.cover,
                //       ),
                //       Text(
                //         "Accedi con Apple",
                //         style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                //       ),
                //     ],
                //   ),
                // ),

                if (!_isWeb2WaveMode) ...[
                  UIHelper.verticalSpace(50.h),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Non hai un account? ",
                            style: TextFontStyle.headline30c27272AtyleWorkSansW700
                                .copyWith(
                                  color: const Color(0xFF52525B),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          TextSpan(
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    NavigationService.navigateToReplacement(
                                      Routes.onboardingScreen1,
                                    );
                                  },
                            text: 'Registrati',
                            style: TextFontStyle.headline30c27272AtyleWorkSansW700
                                .copyWith(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14.sp,
                                  color: const Color(0xFF767EFF),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                UIHelper.verticalSpaceMediumLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
