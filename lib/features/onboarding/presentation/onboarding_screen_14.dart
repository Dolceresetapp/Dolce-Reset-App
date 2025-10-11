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

class OnboardingScreen14 extends StatefulWidget {
  const OnboardingScreen14({super.key});

  @override
  State<OnboardingScreen14> createState() => _OnboardingScreen14State();
}

class _OnboardingScreen14State extends State<OnboardingScreen14> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 14, isBackIcon: true),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Movement + Nutrition + Support = ',
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: 'Scientific Results',
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 35,
                   
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(30.h),

            Image.asset(
              Assets.images.onboard14.path,
              width: 1.sw,
              height: 346.h,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () {
            NavigationService.navigateToReplacement(Routes.onboardingScreen15);
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
