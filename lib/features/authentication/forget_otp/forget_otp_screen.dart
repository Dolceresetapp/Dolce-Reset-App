import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:timer_button/timer_button.dart';

import '../../../common_widget/custom_button.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../networks/api_acess.dart';
import '../../../provider/otp_provider.dart';
import '../widgets/logo_widget.dart';
import '../widgets/pinput_theme.dart';

class ForgetOtpScreen extends StatefulWidget {
  final String email;
  const ForgetOtpScreen({super.key, required this.email});

  @override
  State<ForgetOtpScreen> createState() => _ForgetOtpScreenState();
}

class _ForgetOtpScreenState extends State<ForgetOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.verticalSpace(40.h),

              LogoWidget(title: "Verify your Otp "),

              UIHelper.verticalSpace(50.h),

              /// Pinput Form Field
              Consumer<OtpProvider>(
                builder: (context, provider, child) {
                  return Align(
                    alignment: Alignment.center,
                    child: Form(
                      key: _formKey,
                      child: Pinput(
                        controller: _otpController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        forceErrorState: provider.isOtpInvalid,
                        isCursorAnimationEnabled: true,
                        keyboardType: TextInputType.number,
                        pinAnimationType: PinAnimationType.rotation,
                        cursor: Container(
                          width: 2.w,
                          height: 20.h,
                          color: Colors.red,
                        ),
                        animationCurve: Curves.fastEaseInToSlowEaseOut,
                        textInputAction: TextInputAction.done,
                        length: 4,
                        defaultPinTheme: PinputThemeWidget.defaultTheme(
                          context,
                        ),
                        focusedPinTheme: PinputThemeWidget.focusedTheme(
                          context,
                        ),
                        submittedPinTheme:
                            provider.isOtpInvalid
                                ? PinputThemeWidget.errorTheme(context)
                                : PinputThemeWidget.submittedTheme(context),
                        errorPinTheme: PinputThemeWidget.errorTheme(context),
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        onChanged: (pin) {
                          provider.validateOtp(pin);
                        },
                        onCompleted: (pin) {
                          provider.updateOtp(pin);
                        },
                        validator: (pin) {
                          if (pin == null || pin.isEmpty) {
                            provider.setOtpInvalid(true);
                            return 'Please enter the OTP';
                          } else if (pin.length != 4) {
                            provider.setOtpInvalid(true);
                            return 'The OTP must be 4 digits.';
                          }
                          provider.setOtpInvalid(false);
                          return null;
                        },
                      ),
                    ),
                  );
                },
              ),

              UIHelper.verticalSpace(24.h),

              Align(
                alignment: Alignment.center,
                child: Text(
                  "Didn't receive a code?",
                  style: TextFontStyle.headline30c27272AtyleWorkSansW700
                      .copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w100,
                        color: Color(0xFF78a1cc),
                      ),
                ),
              ),
              UIHelper.verticalSpace(16.h),

              Align(
                alignment: Alignment.center,
                child: TimerButton.builder(
                  builder: (context, timeLeft) {
                    return Text(
                      timeLeft == 0
                          ? "Send code again"
                          : "Send code again in ${timeLeft}s",
                      style: TextFontStyle.headline30c27272AtyleWorkSansW700
                          .copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w100,
                            color: Color(0xFF78a1cc),
                          ),
                    );
                  },
                  onPressed: () {
                      signupResendOtpRxObj
                        .signupResendOtpRx(email: widget.email)
                        .waitingForFuture();
                  },
                  timeOutInSeconds: 120,
                ),
              ),

              UIHelper.verticalSpace(30.h),

              CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    forgetPasswordOtpRxObj
                        .forgetPasswordOtpRx(
                          email: widget.email,
                          otp: _otpController.text.toString(),
                        )
                        .waitingForFuture()
                        .then((success) {
                          if (success) {
                            NavigationService.navigateToWithArgs(
                              Routes.resetPasswordScreen,{
                                "email" : widget.email,
                                "token" : forgetPasswordOtpRxObj.token
                              }
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
                      "Verified OTP",
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
    );
  }
}
