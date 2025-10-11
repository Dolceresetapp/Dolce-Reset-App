import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';

class OnetimeOnbaordWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  final List<Map<String, dynamic>> dataList;

  final int index;
  const OnetimeOnbaordWidget({
    super.key,
    required this.data,
    required this.index,
    required this.dataList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display the image
        Image.asset(
          data["image"],
          width: 150.w,
          height: 150.h,
          fit: BoxFit.contain,
        ),

        // Display the title
        Text(
          data["title"],
          textAlign: TextAlign.center,
          style: TextFontStyle.headline30c27272AtyleWorkSansW700.copyWith(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),

        UIHelper.verticalSpace(25.h),

        // Display the subtitle
        Text(
          data["subtitle"],
          textAlign: TextAlign.center,
          style: TextFontStyle.headline30c27272AtyleWorkSansW700.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
