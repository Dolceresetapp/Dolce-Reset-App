import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/text_font_style.dart';

class FoodCaloriesWidget extends StatelessWidget {
  final String icon;
  final String foodCalories;
  final String title;
  const FoodCaloriesWidget({
    super.key,
    required this.icon,
    required this.foodCalories,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10.w,
          children: [
            SvgPicture.asset(icon, height: 20.h, width: 20.w),
            Text(
              foodCalories,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        Text(
          title,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
