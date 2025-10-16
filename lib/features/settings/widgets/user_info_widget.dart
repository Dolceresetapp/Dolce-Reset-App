import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gritti_app/constants/text_font_style.dart';

class UserInfoWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;

  const UserInfoWidget({
    super.key,
    required this.icon,
    required this.subtitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(icon, width: 20.w, height: 20.h, fit: BoxFit.cover),

        Text(
          title,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF27272A),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),

        Text(
          subtitle,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF52525B),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
