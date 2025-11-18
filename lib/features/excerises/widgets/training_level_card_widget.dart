import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/text_font_style.dart';

class TrainingLevelCardWidget extends StatelessWidget {
  final String icon;
  final String title;
  final int countIcon;
  final VoidCallback? onTap;
  const TrainingLevelCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.countIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: ShapeDecoration(
          color: const Color(0xFFF3EDFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Column(
          spacing: 10.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            countIcon == 1
                ? Image.asset(
                  icon,
                  width: 36.w,
                  height: 36.h,
                  fit: BoxFit.cover,
                )
                : countIcon == 2
                ? Row(
                  spacing: 5.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      icon,
                      width: 36.w,
                      height: 36.h,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      icon,
                      width: 36.w,
                      height: 36.h,
                      fit: BoxFit.cover,
                    ),
                  ],
                )
                : countIcon == 3
                ? Row(
                  spacing: 5.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      icon,
                      width: 36.w,
                      height: 36.h,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      icon,
                      width: 36.w,
                      height: 36.h,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      icon,
                      width: 36.w,
                      height: 36.h,
                      fit: BoxFit.cover,
                    ),
                  ],
                )
                : Image.asset(
                  icon,
                  width: 36.w,
                  height: 36.h,
                  fit: BoxFit.cover,
                ),

            Text(
              title,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
