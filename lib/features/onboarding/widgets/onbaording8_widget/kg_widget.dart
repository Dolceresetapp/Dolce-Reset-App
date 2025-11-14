import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:ruler_slider/ruler_slider.dart';

import '../../../../constants/text_font_style.dart';

class KgWidget extends StatefulWidget {
  double kgValue;

  KgWidget({super.key, required this.kgValue});

  @override
  State<KgWidget> createState() => _KgWidgetState();
}

class _KgWidgetState extends State<KgWidget> {
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
                  widget.kgValue.toStringAsFixed(0).toString(),
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 96.sp,

                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(
                  height: 45.h,
                  child: Text(
                    'kg',
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

          RulerSlider(
            minValue: 0.0,
            maxValue: 500.0,
            initialValue: widget.kgValue,
            rulerHeight: 140.h,
            selectedBarColor: Colors.blue,
            unselectedBarColor: Colors.grey,
            tickSpacing: 10.0,
            valueTextStyle: TextStyle(color: Colors.red, fontSize: 18),
            onChanged: (double value) {
              setState(() {
                widget.kgValue = value;
              });
            },
            showFixedBar: false,
            fixedBarColor: Colors.green,
            fixedBarWidth: 3.0,
            fixedBarHeight: 40.0,
            showFixedLabel: false,

            scrollSensitivity: 5.0,
            enableSnapping: true,
            majorTickInterval: 4,
            labelInterval: 10,
            labelVerticalOffset: 30.h,
            showBottomLabels: true,
            labelTextStyle: TextFontStyle.headLine16cFFFFFFWorkSansW600
                .copyWith(
                  color: const Color(0xFF52525B),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
            majorTickHeight: 30.0,
            minorTickHeight: 10.0,
          ),

          // FlutterRuler(
          //   minValue: 120,
          //   maxValue: ibsValue,
          //   rulerWidth: double.infinity,
          //   rulerHeight: 140.h,

          //   pointerDecoration: PointerDecoration(
          //     color: Color(0xFF777EFF),
          //     pointerWidth: 4.w,
          //     pointerHeight: 200.h,
          //   ),
          //   lineDecoration: LineDecoration(
          //     smallLineDecoration: SmallLineDecoration(
          //       color: Color(0xFFD4D4D8),
          //       lineHeight: 30.h,
          //       lineWidth: 3.w,
          //     ),
          //     mediumLineDecoration: MediumLineDecoration(
          //       color: Colors.grey,
          //       lineHeight: 60.h,
          //       lineWidth: 3.w,
          //     ),
          //     largeLineDecoration: LargeLineDecoration(color: Colors.black),
          //   ),
          //   numberTextStyle: TextFontStyle.headLine16cFFFFFFWorkSansW600
          //       .copyWith(
          //         color: const Color(0xFF52525B),
          //         fontSize: 12.sp,
          //         fontWeight: FontWeight.w400,
          //       ),
          // ),
        ],
      ),
    );
  }
}
