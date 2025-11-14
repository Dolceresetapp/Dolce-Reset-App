import 'package:flutter/cupertino.dart';
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

class OnboardingScreen10 extends StatefulWidget {
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

  const OnboardingScreen10({
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
  });

  @override
  State<OnboardingScreen10> createState() => _OnboardingScreen10State();
}

class _OnboardingScreen10State extends State<OnboardingScreen10> {
  DateTime selectedDate = DateTime(2001, 9, 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 8),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),

            Align(
              child: Text(
                "How old are you?",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 27.sp,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            UIHelper.verticalSpace(30.h),

            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selectedDate,
                      maximumYear: DateTime.now().year,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => selectedDate = newDate);
                      },
                    ),
                  ),
                ),
                // 👇 Overlay a custom border on the selection area
                IgnorePointer(
                  child: Container(
                    height: 40, // height of the highlighted selection area
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xFF777eff), // border color
                        width: 1.w, // border thickness
                      ),
                      color: Color(
                        0xFFe5e9ff,
                      ).withValues(alpha: 0.6), // light background
                    ),
                  ),
                ),
              ],
            ),

            // SizedBox(
            //   height: 200,
            //   child: CupertinoDatePicker(

            //     mode: CupertinoDatePickerMode.date,
            //     initialDateTime: selectedDate,
            //     maximumYear: DateTime.now().year,
            //     onDateTimeChanged: (DateTime newDate) {
            //       setState(() => selectedDate = newDate);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () {
            NavigationService.navigateToWithArgs(Routes.onboardingScreen11, {
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

              "selectedDate" : selectedDate,
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
