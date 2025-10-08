import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/constants/validation.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import '../../../common_widget/custom_button.dart';
import '../../../helpers/toast.dart';
import '../widgets/logo_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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

                LogoWidget(title: "Forget your account Password"),

                UIHelper.verticalSpace(50.h),

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

                UIHelper.verticalSpace(30.h),
                CustomButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      _formKey.currentState!.reset();
                      ToastUtil.showShortToast("Otp Sent Successfully");
                      //   NavigationService.navigateTo(Routes.)
                    }
                  },
                  child: Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue",
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

                UIHelper.verticalSpaceMediumLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
