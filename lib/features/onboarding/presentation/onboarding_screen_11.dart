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

  Widget _scaleLabel(String label, String range) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF52525B),
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          range,
          textAlign: TextAlign.center,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF71717A),
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
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
                  ? Column(
                    children: [
                      Text(
                        '${bmi!.toStringAsFixed(2)} - $bmiCategory',
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                          fontSize: 30.sp,
                          color: Color(0xFFF97316),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Secondo le classificazioni OMS/CDC',
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                          fontSize: 11.sp,
                          color: const Color(0xFF71717A),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                  : const SizedBox(),

              UIHelper.verticalSpace(24.h),

              // BMI Scale Bar (replaces English image)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Row(
                  children: [
                    Expanded(flex: 185, child: Container(height: 14.h, color: const Color(0xFF7CB5EC))),
                    Expanded(flex: 65, child: Container(height: 14.h, color: const Color(0xFF66BB6A))),
                    Expanded(flex: 50, child: Container(height: 14.h, color: const Color(0xFFFFA726))),
                    Expanded(flex: 200, child: Container(height: 14.h, color: const Color(0xFFEF9A9A))),
                  ],
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Expanded(flex: 185, child: _scaleLabel('Sottopeso', '<18.5')),
                  Expanded(flex: 65, child: _scaleLabel('Normale', '18.5-24.9')),
                  Expanded(flex: 50, child: _scaleLabel('Sovrappeso', '25-29.9')),
                  Expanded(flex: 200, child: _scaleLabel('Obesità', '30+')),
                ],
              ),

              UIHelper.verticalSpace(20.h),

              // Info box (replaces English text from image)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE4E4E7)),
                ),
                child: Column(
                  children: [
                    Text(
                      'L\'IMC (Indice di Massa Corporea) ti aiuta a capire se il tuo peso è equilibrato rispetto alla tua altezza.',
                      textAlign: TextAlign.center,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFF27272A),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '👉 È semplicemente un numero che fornisce un\'idea generale della tua forma fisica. Ti aiuta a capire da dove iniziare per migliorare il tuo benessere e monitorare i tuoi progressi nel tempo.',
                      textAlign: TextAlign.center,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFFF566A9),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              UIHelper.verticalSpace(16.h),

              // Citations
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
                      'Fonti e classificazioni IMC:',
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
                        mode: LaunchMode.inAppBrowserView,
                      ),
                      child: Text(
                        '• Organizzazione Mondiale della Sanità (OMS)',
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
                        mode: LaunchMode.inAppBrowserView,
                      ),
                      child: Text(
                        '• Centro per il Controllo e la Prevenzione delle Malattie (CDC)',
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
                      'L\'IMC è uno strumento di screening generale e va interpretato con un professionista sanitario.',
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
