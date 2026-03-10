import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/custom_button.dart';
import '../../constants/app_constants.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import 'loss_widget.dart';

class PlanReadyScreen extends StatefulWidget {
  const PlanReadyScreen({super.key});

  @override
  State<PlanReadyScreen> createState() => _PlanReadyScreenState();
}

class _PlanReadyScreenState extends State<PlanReadyScreen> {
  // Current Weight BMI

  double? gCurrentWeightKg;
  double? gTargetWeightKg;
  double? gHeightMeters;

  double? gCurrentBMI;
  double? gTargetBMI;

  double? gWeightDifference; // current - target

  @override
  void initState() {
    super.initState();
    calculateBMI();
  }

  void calculateBMI() {
    // Height (in onboarding7)
    var heightUnit = appData.read(kKeyonboard7HeightUnit); // inch/cm
    var heightValue =
        double.tryParse("${appData.read(kKeyonboard7HeightValue)}") ?? 0;

    // Current Weight (onboarding8)
    appData.read(kKeyonboard8HeightUnit); // kg
    var currentWeightValue =
        double.tryParse("${appData.read(kKeyonboard8HeightValue)}") ?? 0;

    // Target Weight (onboarding9)
    appData.read(kKeyonboard9HeightUnit); // kg
    var targetWeightValue =
        double.tryParse("${appData.read(kKeyonboard9HeightValue)}") ?? 0;

    // Convert height to meters
    double heightMeters;
    if (heightUnit == "cm") {
      heightMeters = heightValue / 100;
    } else if (heightUnit == "inch") {
      heightMeters = heightValue * 2.54 / 100;
    } else {
      heightMeters = 0;
    }

    gHeightMeters = heightMeters;

    // Convert weight to kg (already kg for both current & target)
    gCurrentWeightKg = currentWeightValue;
    gTargetWeightKg = targetWeightValue;

    // Calculate BMI: kg / m²
    double? currentBmi;
    double? targetBmi;

    if (heightMeters > 0) {
      currentBmi = gCurrentWeightKg! / (heightMeters * heightMeters);
      targetBmi = gTargetWeightKg! / (heightMeters * heightMeters);
    }

    gCurrentBMI = currentBmi;
    gTargetBMI = targetBmi;

    // Weight difference (current - target)
    gWeightDifference = gCurrentWeightKg! - gTargetWeightKg!;

    // Debug
    log("HeightMeters: $gHeightMeters");
    log("CurrentWeightKg: $gCurrentWeightKg");
    log("TargetWeightKg: $gTargetWeightKg");
    log("CurrentBMI: $gCurrentBMI");
    log("TargetBMI: $gTargetBMI");
    log("Weight Difference: $gWeightDifference");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UIHelper.verticalSpace(20.h),
              Text(
                "Il tuo piano personalizzato\ndi 30 giorni è pronto!",
                textAlign: TextAlign.center,
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF000000),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              UIHelper.verticalSpace(16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE5F1),

                  borderRadius: BorderRadius.circular(15.r),
                ),

                child: Text(
                  "Progettato scientificamente per i tuoi obiettivi",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600
                      .copyWith(
                        color: const Color(0xFF000000),
                        fontSize: 14.sp,
                      ),
                ),
              ),

              UIHelper.verticalSpace(10.h),

              Container(
                width: 1.sw,
                padding: EdgeInsetsDirectional.all(16.sp),
                decoration: BoxDecoration(
                  color: Color(0xFFE2448B).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF0073),
                    borderRadius: BorderRadius.circular(25.r),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Attuale",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                          ),
                          Text(
                            "Obiettivo",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                          ),
                        ],
                      ),

                      UIHelper.verticalSpace(16.h),

                      // Middle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${gCurrentWeightKg?.toStringAsFixed(0)} kg",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(fontSize: 30.sp),
                          ),

                          Image.asset(
                            Assets.images.ss.path,
                            width: 40.w,
                            height: 40.h,
                            fit: BoxFit.contain,
                          ),

                          Text(
                            "${gTargetWeightKg?.toStringAsFixed(0)} kg",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(fontSize: 30.sp),
                          ),
                        ],
                      ),
                      UIHelper.verticalSpace(4.h),
                      //Bmi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "IMC ${gCurrentBMI?.toStringAsFixed(2)}",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(fontSize: 12.sp),
                          ),
                          Text(
                            "IMC ${gTargetBMI?.toStringAsFixed(2)}",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(fontSize: 12.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Center(
                        child: Text(
                          'Classificazione OMS/CDC',
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              UIHelper.verticalSpace(12.h),

              // BMI Citations — visible directly on screen
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE4E4E7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fonti IMC: classificazioni basate su linee guida ufficiali',
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFF52525B),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => launchUrl(
                            Uri.parse('https://www.who.int/data/gho/data/themes/topics/topic-details/GHO/body-mass-index'),
                            mode: LaunchMode.inAppBrowserView,
                          ),
                          child: Text(
                            'OMS',
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                              color: const Color(0xFFF566A9),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          '  •  ',
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                            color: const Color(0xFF71717A),
                            fontSize: 11.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => launchUrl(
                            Uri.parse('https://www.cdc.gov/bmi/about/index.html'),
                            mode: LaunchMode.inAppBrowserView,
                          ),
                          child: Text(
                            'CDC',
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                              color: const Color(0xFFF566A9),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          '  —  screening generale',
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                            color: const Color(0xFF71717A),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              UIHelper.verticalSpace(20.h),

              Row(
                spacing: 16.w,
                children: [
                  LossWidget(
                    subtitle: "Perdita di peso",
                    title: "${gWeightDifference?.toStringAsFixed(0)} kg",
                  ),
                  LossWidget(subtitle: "Giorni per stare meglio", title: "30"),
                  LossWidget(subtitle: "Ogni giorno", title: "15min"),
                ],
              ),

              Image.asset(
                Assets.images.group.path,
                width: 1.sw,
                height: 300.h,
                fit: BoxFit.fitWidth,
              ),

              UIHelper.verticalSpace(20.h),

              CustomButton(
                onPressed: () {
                  NavigationService.navigateTo(Routes.customPlanReadyScreen);
                },
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Inizia il piano con 3 giorni gratis",
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
            ],
          ),
        ),
      ),
    );
  }
}
