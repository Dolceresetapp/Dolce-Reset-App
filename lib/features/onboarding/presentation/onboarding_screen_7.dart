import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_app_bar.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../common_widget/app_bar_widget.dart';

class OnboardingScreen7 extends StatefulWidget {
  const OnboardingScreen7({super.key});

  @override
  State<OnboardingScreen7> createState() => _OnboardingScreen7State();
}

class _OnboardingScreen7State extends State<OnboardingScreen7> {
  int _currentValue = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 5, isBackIcon: true),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),
            Text(
              "What is your height?",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 27.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalSpace(30.h),

            NumberPicker(
              zeroPad: true,
              itemWidth: double.infinity,
              itemHeight: 100.h,
              textStyle: TextFontStyle.headline30c27272AtyleWorkSansW700
                  .copyWith(
                    color: const Color(0xFF767EFF),
                    fontSize: 96.sp,
                    fontWeight: FontWeight.w600,
                  ),
              decoration: ShapeDecoration(
                color: const Color(0xFFE5E9FF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: const Color(0xFF767EFF)),
                  borderRadius: BorderRadius.circular(32.r),
                ),
              ),

              value: _currentValue,
              minValue: 0,
              maxValue: 100,
              onChanged: (value) => setState(() => _currentValue = value),
            ),

            UIHelper.verticalSpace(10.h),

            Text(
              "I'm not very tech-savvy, but with \n this app I learned quickly and \n now I feel better.",
              textAlign: TextAlign.center,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color.fromARGB(255, 31, 31, 32),
                fontSize: 21.sp,

                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () {
            //  NavigationService.navigateToReplacement(Routes.onboardingScreen2);
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
                Assets.icons.vector1,
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
