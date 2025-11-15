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

class _OnboardingScreen9State extends State<OnboardingScreen9>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

 
  double ibsValue = 120.0;

  double kgValue = 80.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 7),
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
                  "What is your target weight?",
                  textAlign: TextAlign.center,

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
                    controller: _tabController,
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
                    controller: _tabController,
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
            int selectedTab = _tabController.index;

            final onboard9TargetWeightValue =
                selectedTab == 0 ? ibsValue : kgValue;
            final onboard9TargetWeightUnit = selectedTab == 0 ? "ibs" : "kg";

            // ---------------------------
            // DATA IS VALID → GO NEXT
            // ---------------------------
            NavigationService.navigateToWithArgs(Routes.onboardingScreen10, {
              "onboard1": widget.onboard1,
              "onboard2": widget.onboard2,
              "onboard4": widget.onboard4,
              "onboard5": widget.onboard5,
              "onboard7HeightUnit": widget.onboard7HeightUnit,
              "onboard7HeightValue": widget.onboard7HeightValue,

              "onboard8WeightUnit": widget.onboard8WeightUnit,
              "onboard8WeightValue": widget.onboard8WeightValue,

              "onboard9TargetWeightValue": onboard9TargetWeightValue,
              "onboard9TargetWeightUnit": onboard9TargetWeightUnit,
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
