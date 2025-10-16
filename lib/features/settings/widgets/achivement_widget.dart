import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gritti_app/constants/text_font_style.dart';

class AchivementWidget extends StatelessWidget {
  final String icon;
  final String levelName;
  const AchivementWidget({
    super.key,
    required this.icon,
    required this.levelName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.h,
      children: [
        SvgPicture.asset(icon, width: 54.w, height: 64.h, fit: BoxFit.cover),

        Text(
          levelName,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF52525B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
