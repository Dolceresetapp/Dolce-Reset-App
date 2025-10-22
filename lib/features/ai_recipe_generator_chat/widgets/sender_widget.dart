import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/text_font_style.dart';

class SenderWidget extends StatelessWidget {
  final String title;
  const SenderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 0.5.sw,
         alignment: Alignment.topRight,
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
    );
  }
}
