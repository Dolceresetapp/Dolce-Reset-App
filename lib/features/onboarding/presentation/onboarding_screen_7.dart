import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/features/onboarding/widgets/onbaording7_widget/cm_widget.dart';
import 'package:gritti_app/features/onboarding/widgets/onbaording7_widget/inch_widget.dart';
import 'package:gritti_app/gen/assets.gen.dart';

import '../../../common_widget/app_bar_widget.dart';
import '../../../common_widget/custom_app_bar.dart';
import '../../../common_widget/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';

class OnboardingScreen7 extends StatefulWidget {
  final String onboard1;
  final String onboard2;
  final String onboard4;
  final String onboard5;

  const OnboardingScreen7({
    super.key,
    required this.onboard1,
    required this.onboard2,
    required this.onboard4,
    required this.onboard5,
  });

  @override
  State<OnboardingScreen7> createState() => _OnboardingScreen7State();
}

class _OnboardingScreen7State extends State<OnboardingScreen7>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int cmValue = 162;

  int inchValue = 100;

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
        title: AppBarWidget(currentStep: 5),
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
                  "What is your height?",
                  style: TextFontStyle.headline30c27272AtyleWorkSansW700
                      .copyWith(
                        color: const Color(0xFF27272A),
                        fontSize: 30,
                        fontFamily: 'Work Sans',
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
                    tabs: const [Tab(text: "cm"), Tab(text: "inch")],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      CmWidget(
                        currentValue: cmValue,
                        onChanged: (value) {
                          setState(() {
                            cmValue = value;
                          });
                        },
                      ),
                      InchWidget(
                        currentValue: inchValue,
                        onChanged: (value) {
                          setState(() {
                            inchValue = value;
                          });
                        },
                      ),
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
            // Determine which tab is selected
            final selectedTab = _tabController.index;

            final onboard7HeightValue =
                selectedTab == 0 ? cmValue : inchValue; // get value from state
            final onboard7HeightUnit = selectedTab == 0 ? "cm" : "inch";

          

            // Navigate with data
            NavigationService.navigateToWithArgs(Routes.onboardingScreen8, {
              "onboard1": widget.onboard1,
              "onboard2": widget.onboard2,
              "onboard4": widget.onboard4,
              "onboard5": widget.onboard5,
              "onboard7HeightUnit": onboard7HeightUnit,
              "onboard7HeightValue": onboard7HeightValue,
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
