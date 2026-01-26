import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/constants/validation.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/networks/api_acess.dart';
import 'package:provider/provider.dart';

import '../../../common_widget/custom_button.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/toast.dart';
import '../../../provider/sign_up_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
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
                UIHelper.verticalSpace(40.h),
                Align(child: Image.asset(Assets.images.frame10.path)),

                UIHelper.verticalSpace(56.h),

                Text(
                  "Email Address",
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
                  hintText: "Enter your email address..",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Assets.icons.vector2,
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
                      "Keep me signed in",
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
                        'Forgot Password',
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

                UIHelper.verticalSpace(30.h),
                CustomButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    signInRxObj
                        .signInRx(
                          email: _emailController.text.trim().toString(),
                          password:
                              _passwordController.text.trim().toString(),
                        )
                        .waitingForFuture()
                        .then((success) {
                          if (success) {
                            NavigationService.navigateToReplacement(
                              Routes.dataLoadingScreen,
                            );
                          }
                        });
                  },
                  child: Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign In",
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

                UIHelper.verticalSpace(16.h),

                SvgPicture.asset(Assets.icons.or, width: 1.sw),

                UIHelper.verticalSpace(16.h),

                CustomButton(
                  color: Color(0xFF000000),
                  onPressed: () {
                    NavigationService.navigateToReplacement(
                      Routes.signUpScreen,
                    );
                  },
                  child: Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.icons.vector4,
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "Sign In With Google",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                      ),
                    ],
                  ),
                ),

                UIHelper.verticalSpace(16.h),

                // CustomButton(
                //   color: Color(0xFF000000),
                //   onPressed: () {
                //     NavigationService.navigateToReplacement(
                //       Routes.signUpScreen,
                //     );
                //   },
                //   child: Row(
                //     spacing: 10.w,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       SvgPicture.asset(
                //         Assets.icons.logosFacebook,
                //         width: 20.w,
                //         height: 20.h,
                //         fit: BoxFit.cover,
                //       ),
                //       Text(
                //         "Sign In With Facebook",
                //         style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                //       ),
                //     ],
                //   ),
                // ),
                //    UIHelper.verticalSpace(16.h),
                CustomButton(
                  color: Color(0xFF000000),
                  onPressed: () {
                    NavigationService.navigateToReplacement(
                      Routes.signUpScreen,
                    );
                  },
                  child: Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.icons.appleIcon,
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "Sign In With Apple",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                      ),
                    ],
                  ),
                ),

                UIHelper.verticalSpace(50.h),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have and account? ",
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
                                    Routes.signUpScreen,
                                  );
                                },
                          text: 'Sign Up',

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

                UIHelper.verticalSpaceMediumLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
