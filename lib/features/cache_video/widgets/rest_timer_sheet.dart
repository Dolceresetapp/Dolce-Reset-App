import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';

class RestTimerSheet extends StatelessWidget {
  final int currentRestDuration;
  final Function(int) onSelect;

  const RestTimerSheet({
    super.key,
    required this.currentRestDuration,
    required this.onSelect,
  });

  static const List<int> _options = [0, 10, 15, 20, 30];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),

          // Title
          Text(
            "Tempo di riposo",
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Pausa tra ogni esercizio",
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              color: Colors.grey.shade600,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 24.h),

          // Options
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: _options.map((seconds) {
              final isSelected = seconds == currentRestDuration;
              return GestureDetector(
                onTap: () {
                  onSelect(seconds);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 64.w,
                  height: 72.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF566A9)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFF566A9)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        seconds == 0 ? "Off" : "$seconds",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                            .copyWith(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        seconds == 0 ? "" : "sec",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                            .copyWith(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : Colors.grey.shade600,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
