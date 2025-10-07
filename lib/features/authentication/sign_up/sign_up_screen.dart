import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/constants/validation.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:provider/provider.dart';

import '../../../common_widget/custom_button.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/toast.dart';
import '../../../provider/sign_up_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();

    _nameController.dispose();
    super.dispose();
  }

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
                Align(child: Image.asset(Assets.images.frame11.path)),

                UIHelper.verticalSpace(50.h),

                Text(
                  "Name",
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
                  hintText: "Enter your name",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Assets.icons.vector2,
                ),

                UIHelper.verticalSpace(16.h),
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
                UIHelper.verticalSpace(12.h),

                //Confirm Password Field
                Text(
                  "Confirm Password",
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
                      controller: _confirmController,
                      hintText: "Confirm Password",
                      validator:
                          (value) => confirmPasswordValidation(
                            value,
                            _passwordController.text,
                          ),
                      suffixIcon: IconButton(
                        onPressed: provider.toggleConfirmPasswordVisibility,
                        icon: SvgPicture.asset(
                          colorFilter: ColorFilter.mode(
                            Color(0xFFA1A1AA),
                            BlendMode.srcIn,
                          ),

                          provider.confirmPasswordVisible
                              ? Assets.icons.eyeOn
                              : Assets.icons.eyeOff,
                          width: 20.w,
                          height: 20.h,
                          fit: BoxFit.none,
                        ),
                      ),
                    );
                  },
                ),

                UIHelper.verticalSpace(30.h),
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ToastUtil.showShortToast("Signup Successfully");

                      _passwordController.clear();

                      _formKey.currentState!.reset();
                    }
                  },
                  child: Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                      ),

                      SvgPicture.asset(
                        Assets.icons.vector1,
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.cover,
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
                          text: 'I have already ',
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
                                    Routes.signInScreen,
                                  );
                                },
                          text: 'an account',

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
