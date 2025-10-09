import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../../constants/text_font_style.dart';

class InchWidget extends StatelessWidget {
  final int currentValue;

  final ValueChanged<int> onChanged;
  const InchWidget({
    super.key,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---------- Number Picker ----------
          Stack(
            alignment: Alignment.center,
            children: [
              // Border decoration (center highlight box)
              Container(
                height: 100.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E9FF),
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(
                    color: const Color(0xFF767EFF),
                    width: 1.w,
                  ),
                ),
              ),

              // Actual number picker
              NumberPicker(
                axis: Axis.vertical,
                itemWidth: double.infinity,
                itemHeight: 100.h,
                //   haptics: false,
                infiniteLoop: true,

                selectedTextStyle: TextFontStyle
                    .headline30c27272AtyleWorkSansW700
                    .copyWith(
                      color: const Color(0xFF767EFF),
                      fontSize: 96.sp,
                      fontWeight: FontWeight.w600,
                    ),

                textStyle: TextFontStyle.headline30c27272AtyleWorkSansW700
                    .copyWith(
                      color: const Color(0xFFA1A1AA),
                      fontSize: 60.sp,

                      fontWeight: FontWeight.w600,
                    ),

                value: currentValue,
                minValue: 100,
                maxValue: 500,
                onChanged: onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
