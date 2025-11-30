import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

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
  CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;

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
                "Your personalized 30- \n day plan is ready!",
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
                  "Scientifically designed for your goals",
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
                  color: Color(0xFFE2448B).withValues(alpha: 0.5),
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
                            "Current",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                          ),
                          Text(
                            "Objective",
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
                            "Body Mass Index ${gCurrentBMI?.toStringAsFixed(2)}.",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(fontSize: 12.sp),
                          ),
                          Text(
                            "Body Mass Index ${gTargetBMI?.toStringAsFixed(2)}",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              UIHelper.verticalSpace(30.h),

              Row(
                spacing: 16.w,
                children: [
                  LossWidget(
                    subtitle: "Weight Loss",
                    title: "${gWeightDifference?.toStringAsFixed(0)} kg",
                  ),
                  LossWidget(subtitle: "Days For Feel Better", title: "30"),
                  LossWidget(subtitle: "Everyday", title: "15min"),
                ],
              ),

              // SizedBox(
              //   width: 1.sw,
              //   height: 250.h,
              //   child: Image.asset(
              //     Assets.images.imageCopy.path,

              //     fit: BoxFit.fitWidth,
              //   ),
              // ),
              CarouselSlider.builder(
                itemCount: 3,
                carouselController: carouselController,
                itemBuilder: (context, index, realIndex) {
                  return Image.asset(
                    Assets.images.group.path,
                    width: 1.sw,
                    fit: BoxFit.fitWidth,
                  );
                },

                options: CarouselOptions(
                  height: 300.h,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  enlargeFactor: 0.5,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),

              UIHelper.verticalSpace(20.h),

              CustomButton(
                onPressed: () {
                  NavigationService.navigateTo(Routes.customPlanReadyScreen);
                },
                child: Row(
                  spacing: 10.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Start the plan with 3 days  free",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                    ),

                    SvgPicture.asset(
                      Assets.icons.rightArrows,
                      width: 20.w,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                    UIHelper.verticalSpace(20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
