import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/constants/validation.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/provider/reset_password_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widget/custom_button.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../networks/api_acess.dart';
import '../widgets/logo_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  final String email;
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

                LogoWidget(title: "Reset your password"),

                UIHelper.verticalSpace(50.h),

                Text(
                  "Password",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                UIHelper.verticalSpace(8.h),

                Consumer<ResetPasswordProvider>(
                  builder: (context, provider, child) {
                    return CustomTextField(
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

                Text(
                  "Confirm Password",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                UIHelper.verticalSpace(8.h),

                Consumer<ResetPasswordProvider>(
                  builder: (context, provider, child) {
                    return CustomTextField(
                      obscureText: !provider.confirmPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _confirmPasswordController,
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
                      resetPasswordRxObj
                          .resetPasswordRx(
                            email: widget.email,
                            token: widget.token,
                            password:
                                _passwordController.text.trim().toString(),
                            passwordConfirmation:
                                _confirmPasswordController.text
                                    .trim()
                                    .toString(),
                          )
                          .waitingForFuture()
                          .then((success) {
                            if (success) {
                              NavigationService.navigateToReplacement(
                                Routes.signInScreen,
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
                        "Reset Password",
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

                UIHelper.verticalSpaceMediumLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
