import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/text_font_style.dart';

class LossWidget extends StatelessWidget {
  final String title;

  final String subtitle;
  const LossWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80.h,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Color(0xFFFF0073),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Column(
          spacing: 4.h,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                fontSize: 24.sp,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
