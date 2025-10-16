import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';

class SettingsTitleWidget extends StatelessWidget {
  final String icon;
  final String title;

  const SettingsTitleWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: ShapeDecoration(
        color: const Color(0xFFFAFAFA),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: const Color(0xFFE4E4E7)),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),

      child: Row(
        spacing: 16.w,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.h,
            fit: BoxFit.contain,
          ),

          Text(
            title,
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              color: const Color(0xFF27272A),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          Spacer(),
          SvgPicture.asset(
            Assets.icons.chevronRight,
            width: 24.w,
            height: 24.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
