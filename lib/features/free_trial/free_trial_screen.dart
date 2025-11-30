import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/gen/assets.gen.dart';

import '../../common_widget/custom_button.dart';
import '../../common_widget/custom_svg_asset.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../helpers/ui_helpers.dart';

class FreeTrialScreen extends StatefulWidget {
  const FreeTrialScreen({super.key});

  @override
  State<FreeTrialScreen> createState() => _FreeTrialScreenState();
}

class _FreeTrialScreenState extends State<FreeTrialScreen> {
  bool isChecked = false;

  void toogleChange(bool value) {
    setState(() {
      isChecked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              UIHelper.verticalSpace(20.h),

              InkWell(
                onTap: () {
                  NavigationService.goBack;
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: CustomSvgAsset(
                      width: 20.w,
                      height: 20.h,
                      color: Color(0xFF27272A),
                      fit: BoxFit.contain,
                      assetName: Assets.icons.icon,
                    ),
                  ),
                ),
              ),
              UIHelper.verticalSpace(20.h),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "We'll send you a reminder before your free trial ends",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF000000),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              UIHelper.verticalSpace(50.h),

              Image.asset(
                Assets.images.frameBellIcon.path,
                width: 1.sw,
                height: 268.h,
                fit: BoxFit.contain,
              ),

              // UIHelper.verticalSpace(50.h),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   spacing: 10.w,

              //   children: [
              //     MSHCheckbox(
              //       style: MSHCheckboxStyle.fillScaleCheck,
              //       size: 20.sp,
              //       value: isChecked,
              //       onChanged: (value) => toogleChange(value),
              //       colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
              //         checkedColor: Color(0xFFF566A9),
              //         uncheckedColor: Color(0xFFD4D4D8),
              //       ),
              //     ),

              //     Text(
              //       "No payment Due now",
              //       textAlign: TextAlign.center,
              //       style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              //         color: const Color(0xFF000000),
              //         fontSize: 14.sp,
              //         fontWeight: FontWeight.w800,
              //       ),
              //     ),
              //   ],
              // ),
              UIHelper.verticalSpace(20.h),

              CustomButton(
                onPressed: () {
                  NavigationService.navigateTo(Routes.trialContinueScreen);
                },
                child: Row(
                  spacing: 10.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue for FREE",
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

              UIHelper.verticalSpace(10.h),

              Text(
                "3 days free, then €69.99 per year (€4.75 /mo)",
                textAlign: TextAlign.center,
                style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600.copyWith(
                  color: const Color(0xFF000000),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
