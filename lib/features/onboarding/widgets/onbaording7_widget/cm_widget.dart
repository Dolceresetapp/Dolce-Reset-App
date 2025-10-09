import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../common_widget/custom_button.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/navigation_service.dart';

class CmWidget extends StatelessWidget {
  final int currentValue;

  final ValueChanged<int> onChanged;
  const CmWidget({
    super.key,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---------- Number Picker ----------
          Stack(
            alignment: Alignment.center,
            children: [
              // Border decoration (center highlight box)
              Container(
                height: 100.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E9FF),
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(
                    color: const Color(0xFF767EFF),
                    width: 1.w,
                  ),
                ),
              ),

              // Actual number picker
              NumberPicker(
                axis: Axis.vertical,
                itemWidth: double.infinity,
                itemHeight: 100.h,
                //   haptics: false,
                infiniteLoop: true,

                selectedTextStyle: TextFontStyle
                    .headline30c27272AtyleWorkSansW700
                    .copyWith(
                      color: const Color(0xFF767EFF),
                      fontSize: 96.sp,
                      fontWeight: FontWeight.w600,
                    ),

                textStyle: TextFontStyle.headline30c27272AtyleWorkSansW700
                    .copyWith(
                      color: const Color(0xFFA1A1AA),
                      fontSize: 60.sp,

                      fontWeight: FontWeight.w600,
                    ),

                value: currentValue,
                minValue: 100,
                maxValue: 500,
                onChanged: onChanged,
              ),
            ],
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomButton(
        onPressed: () {
          NavigationService.navigateToReplacement(Routes.onboardingScreen7);
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
    );
  }
}
