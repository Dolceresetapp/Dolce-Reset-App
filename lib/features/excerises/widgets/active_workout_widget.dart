import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';

class ActiveWorkoutWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String time;
  final String text;
  const ActiveWorkoutWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFFAFAFA),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE4E4E7)),
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      child: Row(
        spacing: 12.w,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              Assets.images.frame4.path,
              width: 88.w,
              height: 88.h,
              fit: BoxFit.contain,
            ),
          ),

          Expanded(
            flex: 3,
            child: Column(
              spacing: 8.h,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 16.sp,

                    fontWeight: FontWeight.w600,
                  ),
                ),

                Row(
                  spacing: 9.w,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: const Color(0xFF52525B),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),

                    Container(
                      width: 4.w,
                      height: 4.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD4D4D8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ),

                    Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: const Color(0xFF52525B),
                            fontSize: 14.sp,

                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Image.asset(
              Assets.images.chevronRight.path,
              width: 24.w,
              height: 24.h,
            ),
          ),
        ],
      ),
    );
  }
}
