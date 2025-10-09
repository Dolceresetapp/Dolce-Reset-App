import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import '../../../constants/text_font_style.dart';

class TileCardWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  const TileCardWidget({
    super.key,
    required this.icon,
    required this.isChecked,
    required this.title,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.sp),
        decoration: ShapeDecoration(
          color: isChecked ? const Color(0xFFE5E8FF) : const Color(0xFFFAFAFA),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.w,
              color:
                  isChecked ? const Color(0xFF767EFF) : const Color(0xFFE4E4E7),
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),

        child: Row(
          spacing: 12.w,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(icon, width: 48.w, height: 48.h, fit: BoxFit.fill),

            // Title
            Expanded(
              child: Column(
                spacing: 4.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    subtitle ?? "",
                    maxLines: 2,
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF52525B),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            MSHCheckbox(
              style: MSHCheckboxStyle.fillScaleCheck,
              size: 20.sp,
              value: isChecked,
              onChanged: onChanged,
              colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                checkedColor: Color(0xFF777EFF),
                uncheckedColor: Color(0xFFD4D4D8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
