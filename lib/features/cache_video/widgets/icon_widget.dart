import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class IconWidget extends StatelessWidget {
  final String icon;
  const IconWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(icon, width: 40.w, height: 40.h, fit: BoxFit.cover);
  }
}
