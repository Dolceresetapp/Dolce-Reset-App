import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/text_font_style.dart';

class AiCardWidget extends StatelessWidget {
  final VoidCallback onTap;

  final String image;

  final String title;

  const AiCardWidget({super.key, required this.onTap, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.sp),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFFAFAFA),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.w, color: const Color(0xFFE4E4E7)),
            borderRadius: BorderRadius.circular(24.sp),
          ),
        ),
        child: Column(
          spacing: 16.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, width: 67.w, height: 67.h),

            Text(
             title,
              textAlign: TextAlign.center,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF52525B),

                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
