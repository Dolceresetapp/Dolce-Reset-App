import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';

class LogoWidget extends StatelessWidget {
  final String title;
  const LogoWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16.h,
      children: [
        Align(
          child: Image.asset(
            Assets.images.logo.path,
            width: 110.w,
            height: 80.h,
            fit: BoxFit.contain,
          ),
        ),

        Text(
          title,
          textAlign: TextAlign.center,
          style: TextFontStyle.headline30c27272AtyleWorkSansW700.copyWith(
            color: const Color(0xFF52525B),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
