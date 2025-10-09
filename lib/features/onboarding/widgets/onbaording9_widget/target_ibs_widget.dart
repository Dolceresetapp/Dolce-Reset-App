import 'package:flutter/material.dart';
import 'package:flutter_ruler/flutter_ruler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../../constants/text_font_style.dart';


class TargetIbsWidget extends StatelessWidget {
  final int ibsValue;


  const TargetIbsWidget({super.key, required this.ibsValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ibsValue.toString(),
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 96.sp,

                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(
                  height: 45.h,
                  child: Text(
                    'lbs',
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF52525B),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
          ),

          UIHelper.verticalSpace(20.h),

          FlutterRuler(
            minValue: 120, 
            maxValue: ibsValue,
            rulerWidth: double.infinity,
            rulerHeight: 140.h,
            pointerDecoration: PointerDecoration(
              color: Color(0xFF777EFF),
              pointerWidth: 4.w,
              pointerHeight: 200.h,
            ),
            lineDecoration: LineDecoration(
              smallLineDecoration: SmallLineDecoration(
                color: Color(0xFFD4D4D8),
                lineHeight: 30.h,
                lineWidth: 3.w,
              ),
              mediumLineDecoration: MediumLineDecoration(
                color: Colors.grey,
                lineHeight: 60.h,
                lineWidth: 3.w,
              ),
              largeLineDecoration: LargeLineDecoration(color: Colors.black),
            ),
            numberTextStyle: TextFontStyle.headLine16cFFFFFFWorkSansW600
                .copyWith(
                  color: const Color(0xFF52525B),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),

    
    );
  }
}
