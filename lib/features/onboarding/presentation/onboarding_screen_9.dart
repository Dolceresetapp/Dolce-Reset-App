import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ruler_slider/ruler_slider.dart';

import '../../../common_widget/app_bar_widget.dart';
import '../../../common_widget/custom_app_bar.dart';
import '../../../common_widget/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/ui_helpers.dart';

class OnboardingScreen9 extends StatefulWidget {
  final String onboard1;
  final String onboard2;
  final String onboard4;
  final String onboard5;
  final int onboard7HeightValue;
  final String onboard7HeightUnit;

  final double onboard8WeightValue;
  final String onboard8WeightUnit;

  const OnboardingScreen9({
    super.key,

    required this.onboard1,
    required this.onboard2,
    required this.onboard4,
    required this.onboard5,
    required this.onboard7HeightValue,
    required this.onboard7HeightUnit,

    required this.onboard8WeightUnit,
    required this.onboard8WeightValue,
  });

  @override
  State<OnboardingScreen9> createState() => _OnboardingScreen9State();
}

class _OnboardingScreen9State extends State<OnboardingScreen9> {
  double kgValue = 80.0;

  @override
  Widget build(BuildContext context) {
    log("onboard8WeightValue : ${widget.onboard8WeightValue}");
    log("onboard8WeightUnit : ${widget.onboard8WeightUnit}");
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 7),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text(
                "What is your target weight?",
                textAlign: TextAlign.center,
                style: TextFontStyle.headline30c27272AtyleWorkSansW700.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              UIHelper.verticalSpace(30.h),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      kgValue.toStringAsFixed(0).toString(),
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: const Color(0xFF27272A),
                            fontSize: 96.sp,

                            fontWeight: FontWeight.w700,
                          ),
                    ),

                    SizedBox(
                      height: 45.h,
                      child: Text(
                        'kg',
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                            .copyWith(
                              color: const Color(0xFF52525B),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w200,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              UIHelper.verticalSpace(20.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: RulerSlider(
                  minValue: 30.0,
                  maxValue: 200.0,
                  initialValue: kgValue,
                  rulerHeight: 140.h,
                  selectedBarColor: Colors.blue,
                  unselectedBarColor: Colors.grey,
                  tickSpacing: 10.0,
                  valueTextStyle: TextStyle(color: Colors.red, fontSize: 18),
                  onChanged: (double value) {
                    setState(() {
                      kgValue = value;
                    });
                  },
                  showFixedBar: false,
                  fixedBarColor: Colors.green,
                  fixedBarWidth: 3.0,
                  fixedBarHeight: 40.0,
                  showFixedLabel: false,

                  scrollSensitivity: 5.0,
                  enableSnapping: true,
                  majorTickInterval: 4,
                  labelInterval: 10,
                  labelVerticalOffset: 30.h,
                  showBottomLabels: true,
                  labelTextStyle: TextFontStyle.headLine16cFFFFFFWorkSansW600
                      .copyWith(
                        color: const Color(0xFF52525B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                  majorTickHeight: 30.0,
                  minorTickHeight: 10.0,
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () {
            NavigationService.navigateToWithArgs(Routes.onboardingScreen10, {
              "onboard1": widget.onboard1,
              "onboard2": widget.onboard2,
              "onboard4": widget.onboard4,
              "onboard5": widget.onboard5,
              "onboard7HeightUnit": widget.onboard7HeightUnit,
              "onboard7HeightValue": widget.onboard7HeightValue,

              "onboard8WeightUnit": widget.onboard8WeightUnit,
              "onboard8WeightValue": widget.onboard8WeightValue,

              "onboard9TargetWeightValue": kgValue,
              "onboard9TargetWeightUnit": "kg",
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
