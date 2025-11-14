import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_app_bar.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../common_widget/app_bar_widget.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';

class OnboardingScreen14 extends StatefulWidget {
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

  final String onboard12;

  final String onboard13;

  const OnboardingScreen14({
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

    required this.onboard12,

    required this.onboard13,
  });

  @override
  State<OnboardingScreen14> createState() => _OnboardingScreen14State();
}

class _OnboardingScreen14State extends State<OnboardingScreen14> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 11),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),
            Text(
              "You have great potential to smash any finish line",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 27.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(30.h),

            Image.asset(
              Assets.images.pnboard11.path,
              width: 1.sw,
              height: 346.h,
              fit: BoxFit.fill,
            ),

            UIHelper.verticalSpace(10.h),

            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(
                    text: 'RESULT: Profile Similar to Ours \n',
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: 'Successes: Excellent Chances Of \n',

                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFFF4349D),
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: 'Achieve Your Goals!',
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
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
            NavigationService.navigateToWithArgs(Routes.onboardingScreen15, {
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

              "onboard12": widget.onboard12,

              "onboard13": widget.onboard13,
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
