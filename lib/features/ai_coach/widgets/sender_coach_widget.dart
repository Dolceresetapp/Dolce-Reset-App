import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/text_font_style.dart';

class SenderCoachWidget extends StatelessWidget {
  final String title;
  const SenderCoachWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.7.sw),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: ShapeDecoration(
            color: const Color(0xFFF566A9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.r),
            ),
          ),
          child: Text(
            title,
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              color: Colors.white,
              fontSize: 12.sp,

              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
