import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_app_bar.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';

import '../../../common_widget/app_bar_widget.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/ui_helpers.dart';

class OnboardingScreen16 extends StatefulWidget {
  final String onboard1;
  final String onboard2;
  final String onboard4;
  final String onboard5;
  final int onboard7HeightValue;
  final String onboard7HeightUnit;

  final double onboard8WeightValue;
  final String onboard8WeightUnit;

  final double onboard9TargetWeightValue;
  final String onboard9TargetWeightUnit;

  final DateTime selectedDate;

  final double bmi;

  final String onboard12;

  final String onboard13;

  final String onboard15;

  const OnboardingScreen16({
    super.key,

    required this.onboard1,
    required this.onboard2,
    required this.onboard4,
    required this.onboard5,
    required this.onboard7HeightValue,
    required this.onboard7HeightUnit,

    required this.onboard8WeightUnit,
    required this.onboard8WeightValue,

    required this.onboard9TargetWeightValue,
    required this.onboard9TargetWeightUnit,

    required this.selectedDate,

     required this.bmi,

    required this.onboard12,

    required this.onboard13,

    required this.onboard15,
  });

  @override
  State<OnboardingScreen16> createState() => _OnboardingScreen16State();
}

class _OnboardingScreen16State extends State<OnboardingScreen16> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 13),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(40.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Prova Gratis 3 Giorni! \n Vedi Se Ti Piace",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  fontSize: 24.sp,
                  color: Colors.black,
                ),
              ),
            ),
            UIHelper.verticalSpace(20.h),
            Image.asset(
              Assets.images.onboard16.path,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.contain,
            ),

            UIHelper.verticalSpace(20.h),

            Align(
              alignment: Alignment.center,
              child: Text(
                "To support the quality of the service after the free trial we ask you for a small contribution if you like the app.",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () {
            NavigationService.navigateToWithArgs(Routes.onboardingScreen17, {
              "onboard1": widget.onboard1,
              "onboard2": widget.onboard2,
              "onboard4": widget.onboard4,
              "onboard5": widget.onboard5,
              "onboard7HeightUnit": widget.onboard7HeightUnit,
              "onboard7HeightValue": widget.onboard7HeightValue,

              "onboard8WeightUnit": widget.onboard8WeightUnit,
              "onboard8WeightValue": widget.onboard8WeightValue,

              "onboard9TargetWeightValue": widget.onboard9TargetWeightValue,
              "onboard9TargetWeightUnit": widget.onboard9TargetWeightUnit,

              "selectedDate": widget.selectedDate,

                 "bmi" : widget.bmi,

              "onboard12": widget.onboard12,

              "onboard13": widget.onboard13,

              "onboard15": widget.onboard15,
            });
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
                Assets.icons.rightArrows,
                width: 20.w,
                height: 20.h,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
