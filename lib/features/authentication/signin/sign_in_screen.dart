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

  // Steps: 'email' → 'password' → login | 'set_password' → redeem
  String _step = 'email';
  bool _isLoading = false;
  bool ischecked = false;

  @override
  void initState() {
    super.initState();
    preloadService.preloadOnLoginScreen();

    // Pre-fill email if coming from Web2Wave deep link
    final web2waveEmail = appData.read('web2wave_email');
    if (web2waveEmail != null && web2waveEmail.toString().isNotEmpty) {
      _emailController.text = web2waveEmail;
      appData.remove('web2wave_email');
      // Go straight to checking this email
      _checkEmail();
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

  /// Step 1: Check email — determines next step
  Future<void> _checkEmail() async {
    final email = _emailController.text.trim().toLowerCase();
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      ToastUtil.showShortToast('Inserisci un indirizzo email valido');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = Dio(BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      ));

      final response = await dio.post(
        Endpoints.checkEmail(),
        data: {'email': email},
      );

      if (response.data is Map) {
        final exists = response.data['exists'] == true;
        final needsPassword = response.data['needs_password'] == true;

        if (!exists) {
          ToastUtil.showShortToast('Nessun account trovato con questa email');
        } else if (needsPassword) {
          // Web2Wave user who never set password
          log('[SignIn] Web2Wave user needs password → set_password step');
          setState(() => _step = 'set_password');
        } else {
          // Normal user with password
          log('[SignIn] User exists → password step');
          setState(() => _step = 'password');
        }
      }
    } catch (e) {
      log('[SignIn] check-email error: $e');
      // On error, default to password step (worst case they get "invalid password")
      setState(() => _step = 'password');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Step 2a: Normal login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dio = Dio(BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ));

      final response = await dio.post(
        Endpoints.signIn(),
        data: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['status'] == true) {
        final token = response.data['token'];
        final data = response.data['data'];

        appData.write(kKeyAccessToken, token);
        appData.write(kKeyID, data['id']);
        appData.write(kKeyName, data['name'] ?? '');
        appData.write(kKeyEmail, data['email'] ?? '');
        appData.write(kKeyAvatar, data['avatar'] ?? '');
        appData.write(kKeyIsNutration, data['is_nutration'] ?? 0);

        // Handle user_info and payment_method
        int backendUserInfo = data['user_info'] ?? 0;
        appData.write(kKeyUsrInfo, backendUserInfo);

        int backendPayment = data['Payment_method'] ?? data['payment_method'] ?? 0;
        appData.write(kKeyPaymentMethod, backendPayment);

        // Save payment source
        final paymentSource = data['payment_source'];
        if (paymentSource != null && paymentSource.toString().isNotEmpty) {
          appData.write('payment_source', paymentSource);
        }

        appData.write(kKeyIsLoggedIn, true);
        appData.remove(kKeyIsGuest);
        DioSingleton.instance.update(token);

        log('[SignIn] Login success, navigating to loading...');
        NavigationService.navigateToUntilReplacement(Routes.loadingScreen);
      } else {
        final msg = response.data is Map
            ? response.data['message']
            : 'Errore di accesso';
        ToastUtil.showShortToast(msg ?? 'Errore di accesso');
      }
    } catch (e) {
      log('[SignIn] Login error: $e');
      ToastUtil.showShortToast('Errore di connessione. Riprova.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Step 2b: Web2Wave set-password + auto-login
  Future<void> _redeemWeb2Wave() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xFF000000).withValues(alpha: 0.3),
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final dio = Dio(BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        followRedirects: false,
        validateStatus: (status) => status != null && status < 500,
      ));

      final response = await dio.post(
        Endpoints.setPassword(),
        data: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'password_confirmation': _confirmPasswordController.text.trim(),
          'name': _nameController.text.trim(),
        },
      );

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['status'] == true) {
        final token = response.data['token'];
        final data = response.data['data'];

        appData.write(kKeyAccessToken, token);
        appData.write(kKeyID, data['id']);
        appData.write(kKeyName, data['name'] ?? '');
        appData.write(kKeyEmail, data['email'] ?? '');
        appData.write(kKeyAvatar, data['avatar'] ?? '');
        appData.write(kKeyUsrInfo, 1);
        appData.write(kKeyPaymentMethod, 1);
        appData.write('payment_source', 'web2wave');
        appData.write(kKeyIsNutration, data['is_nutration'] ?? 0);
        appData.write(kKeyIsLoggedIn, true);
        appData.remove(kKeyIsGuest);
        appData.remove('web2wave_email');
        appData.remove('web2wave_user_id');

        DioSingleton.instance.update(token);
        NavigationService.navigateToUntilReplacement(Routes.loadingScreen);
      } else if (response.statusCode == 409) {
        // User already set their password — switch to normal login
        if (mounted) Navigator.of(context).pop();
        log('[SignIn] Web2Wave user already has password, switching to login');
        setState(() => _step = 'password');
        ToastUtil.showShortToast('Hai già una password. Accedi con le tue credenziali.');
      } else {
        if (mounted) Navigator.of(context).pop();
        final msg = response.data is Map
            ? response.data['message']
            : 'Errore durante la registrazione';
        ToastUtil.showShortToast(msg ?? 'Errore durante la registrazione');
      }
    } on DioException catch (e) {
      if (mounted) Navigator.of(context).pop();
      final data = e.response?.data;
      final serverMessage = data is Map ? data['message'] : null;
      ToastUtil.showShortToast(serverMessage ?? 'Errore di connessione. Riprova.');
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      ToastUtil.showShortToast('Errore di connessione. Riprova.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSetPassword = _step == 'set_password';
    final showPasswordFields = _step == 'password' || _step == 'set_password';

    String title;
    if (_step == 'email') {
      title = "Accedi al tuo account";
    } else if (isSetPassword) {
      title = "Completa la registrazione";
    } else {
      title = "Accedi al tuo account";
    }

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
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      if (_step != 'email') {
                        // Go back to email step
                        setState(() {
                          _step = 'email';
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                          _nameController.clear();
                        });
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 22.w,
                      color: const Color(0xFF27272A),
                    ),
                  ),
                ),
                UIHelper.verticalSpace(16.h),
                LogoWidget(title: title),

                // Info banner for Web2Wave users
                if (isSetPassword) ...[
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
                            "Crea una password per accedere all'app.",
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

                UIHelper.verticalSpace(isSetPassword ? 24.h : 56.h),

                // Name field (only for set_password)
                if (isSetPassword) ...[
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

                // Email field (always visible)
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
                  readOnly: showPasswordFields,
                  filled: showPasswordFields,
                  fillColor: showPasswordFields ? const Color(0xFFE4E4E7) : null,
                ),

                // Password field (only after email check)
                if (showPasswordFields) ...[
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
                ],

                // Confirm password (only for set_password)
                if (isSetPassword) ...[
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

                // Remember me + Forgot password (only for normal login)
                if (_step == 'password') ...[
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
                          NavigationService.navigateToWithArgs(
                            Routes.forgetPasswordScreen,
                            {'email': _emailController.text.trim()},
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

                // Main action button
                CustomButton(
                  onPressed: () {
                    if (_isLoading) return;
                    if (_step == 'email') {
                      _checkEmail();
                    } else if (_step == 'set_password') {
                      _redeemWeb2Wave();
                    } else {
                      _handleLogin();
                    }
                  },
                  child: _isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          spacing: 10.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _step == 'email'
                                  ? "Continua"
                                  : isSetPassword
                                      ? "Completa e accedi"
                                      : "Accedi",
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

                // "Non hai un account? Registrati" (only on email step)
                if (_step == 'email') ...[
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
