import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/features/onboarding/widgets/onbaording8_widget/ibs_widget.dart';
import 'package:gritti_app/features/onboarding/widgets/onbaording8_widget/kg_widget.dart';

import '../../../common_widget/app_bar_widget.dart';
import '../../../common_widget/custom_app_bar.dart';
import '../../../common_widget/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';

class OnboardingScreen8 extends StatefulWidget {
  const OnboardingScreen8({super.key});

  @override
  State<OnboardingScreen8> createState() => _OnboardingScreen8State();
}

class _OnboardingScreen8State extends State<OnboardingScreen8> {
  int ibsValue = 162;

  int kgValue = 300;

  @override
  Widget build(BuildContext context) {
    log(ibsValue.toString());
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 8, isBackIcon: true, maxSteps : 15),
      ),
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: SafeArea(
            child: Column(
              spacing: 30.h,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "What is your weight?",
                  style: TextFontStyle.headline30c27272AtyleWorkSansW700
                      .copyWith(
                        color: const Color(0xFF27272A),
                        fontSize: 30,

                        fontWeight: FontWeight.w700,
                      ),
                ),
                // TabBar : Tabs
                Container(
                  // Unselected Background Color
                  height: 55.h,
                  padding: EdgeInsets.all(4.sp),
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F4F5),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,

                    // Text styles
                    labelStyle: TextFontStyle.headline30c27272AtyleWorkSansW700
                        .copyWith(
                          color: const Color(0xFF27272A),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                    unselectedLabelStyle: TextFontStyle
                        .headline30c27272AtyleWorkSansW700
                        .copyWith(
                          color: const Color(0xFF52525B),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),

                    // Tab indicator
                    indicator: BoxDecoration(
                      color: AppColors.cFFFFFF,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    tabs: const [Tab(text: "Ibs"), Tab(text: "Kg")],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      IbsWidget(ibsValue: ibsValue),
                      KgWidget(kgValue: kgValue),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () {
            NavigationService.navigateTo(Routes.onboardingScreen9);
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
