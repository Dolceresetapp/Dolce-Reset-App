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
import '../../../helpers/toast.dart';
import '../widgets/tile_card_widget.dart';

class OnboardingScreen15 extends StatefulWidget {
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

     final double bmi;

  final String onboard12;

  final String onboard13;

  const OnboardingScreen15({
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

     required this.bmi,

    required this.onboard12,

    required this.onboard13,
  });

  @override
  State<OnboardingScreen15> createState() => _OnboardingScreen15State();
}

class _OnboardingScreen15State extends State<OnboardingScreen15> {
  List<Map<String, dynamic>> dataList = [
    {"image": Assets.images.onboard151.path, "title": "Very satisfied"},

    {"image": Assets.images.onboard152.path, "title": "Quite satisfied"},

    {"image": Assets.images.onboard153.path, "title": "Not very satisfied"},

    {"image": Assets.images.onboard154.path, "title": "Not at all satisfied"},
  ];

  int? selectedIndex;

  String? onboard15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 12),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),
            Text(
              "In the last 6 months, how satisfied have you been with your body?",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 27.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(30.h),

            ListView.builder(
              itemCount: dataList.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                var data = dataList[index];
                bool isChecked = selectedIndex == index;
                return TileCardWidget(
                  icon: data["image"],
                  isChecked: isChecked,
                  title: data["title"],
                  isSubtitle: true,
                  onChanged: (value) {
                    setState(() {
                      if (selectedIndex == index) {
                        selectedIndex = null;
                      } else {
                        selectedIndex = index;
                        onboard15 = data["title"];
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () {
            if (selectedIndex == null) {
              ToastUtil.showErrorShortToast("Please select an item.");
            } else {
              NavigationService.navigateToWithArgs(Routes.onboardingScreen16, {
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

                   "bmi" : widget.bmi,

                "onboard12": widget.onboard12,

                "onboard13": widget.onboard13,

                "onboard15": onboard15,
              });
            }
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
