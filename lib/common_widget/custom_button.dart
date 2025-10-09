import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/text_font_style.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final EdgeInsetsGeometry? padding;
  final double? minWidth;
  final Color? color;
  final TextStyle? style;
  final BorderSide? borderSide;
  final double? borderRadius;
  final Widget? child;
  const CustomButton({
    super.key,
    required this.onPressed,
    this.text,
    this.padding,
    this.minWidth,
    this.color,
    this.style,
    this.borderSide,
    this.borderRadius,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding:
          padding ?? EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      minWidth: minWidth ?? 1.sw,
      color: color ?? Color(0xFFF566A9),
      shape: RoundedRectangleBorder(
        side: borderSide ?? BorderSide.none,
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
      ),
      child:
          child ??
          Text(
            text ?? "",
            style: style ?? TextFontStyle.headLine16cFFFFFFWorkSansW600,
          ),
    );
  }
}
