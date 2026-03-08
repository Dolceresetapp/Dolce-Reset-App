import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widget/custom_button.dart';
import '../../../common_widget/custom_svg_asset.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';

class OnboardingScreen11 extends StatefulWidget {
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

  const OnboardingScreen11({
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
  });

  @override
  State<OnboardingScreen11> createState() => _OnboardingScreen11State();
}

class _OnboardingScreen11State extends State<OnboardingScreen11> {
  double? bmi;
  String bmiCategory = '';

  @override
  void initState() {
    super.initState();
    calculateBMI();
  }

  void calculateBMI() {
    double weight = widget.onboard8WeightValue;
    double height = double.tryParse(widget.onboard7HeightValue.toString()) ?? 0;

    if (weight <= 0 || height <= 0) return;

    double weightKg =
        widget.onboard8WeightUnit == 'lbs' ? weight * 0.453592 : weight;
    double heightM =
        widget.onboard7HeightUnit == 'cm' ? height / 100 : height * 2.54 / 100;

    double result = weightKg / (heightM * heightM);

    String category = '';
    if (result < 18.5) {
      category = 'Sottopeso';
    } else if (result < 25) {
      category = 'Normale';
    } else if (result < 30) {
      category = 'Sovrappeso';
    } else {
      category = 'Obesità';
    }

    setState(() {
      bmi = result;
      bmiCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("onboard7HeightValue : ${widget.onboard7HeightValue}");
    log("onboard7HeightUnit : ${widget.onboard7HeightUnit}");

    //
    log("onboard8WeightUnit : ${widget.onboard8WeightUnit}");
    log("onboard8WeightValue : ${widget.onboard8WeightValue}");

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),

        child: SafeArea(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  NavigationService.goBack;
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CustomSvgAsset(
                    width: 20.w,
                    height: 20.h,
                    color: Color(0xFF27272A),
                    fit: BoxFit.contain,
                    assetName: Assets.icons.icon,
                  ),
                ),
              ),
              UIHelper.verticalSpace(40.h),
              Text(
                'Ecco il Tuo \n INDICE DI MASSA CORPOREA',
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  fontSize: 20.sp,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              UIHelper.verticalSpace(20.h),
              bmi != null
                  ? Text(
                    '${bmi!.toStringAsFixed(2)} - $bmiCategory',
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      fontSize: 30.sp,
                      color: Color(0xFFF97316),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                  : const SizedBox(),

              Image.asset(Assets.images.onboard11.path),

              UIHelper.verticalSpace(16.h),

              // BMI Citations — visible directly on screen
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                margin: EdgeInsets.only(bottom: 100.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE4E4E7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fonti e classificazioni BMI:',
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFF52525B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: () => launchUrl(
                        Uri.parse('https://www.who.int/data/gho/data/themes/topics/topic-details/GHO/body-mass-index'),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Text(
                        '• World Health Organization (WHO)',
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                          color: const Color(0xFFF566A9),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: () => launchUrl(
                        Uri.parse('https://www.cdc.gov/bmi/about/index.html'),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Text(
                        '• Centers for Disease Control and Prevention (CDC)',
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                          color: const Color(0xFFF566A9),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Il BMI è uno strumento di screening generale e va interpretato con un professionista sanitario.',
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFF71717A),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
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
            NavigationService.navigateToWithArgs(Routes.onboardingScreen12, {
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

              "bmi" : bmi
            });
          },
          child: Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Continua",
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
