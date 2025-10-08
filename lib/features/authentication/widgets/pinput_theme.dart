import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../../../constants/text_font_style.dart';

class PinputThemeWidget {
  static PinTheme defaultTheme(BuildContext context) {
    return PinTheme(
      width: 56.w,
      height: 60.h,
      textStyle: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFf3f4f7),
        borderRadius: BorderRadius.circular(15.r),
      ),
    );
  }

  static PinTheme focusedTheme(BuildContext context) {
    return defaultTheme(
      context,
    ).copyDecorationWith(borderRadius: BorderRadius.circular(15.r));
  }

  static PinTheme submittedTheme(BuildContext context) {
    return defaultTheme(
      context,
    ).copyDecorationWith(borderRadius: BorderRadius.circular(15.r));
  }

  static PinTheme errorTheme(BuildContext context) {
    return defaultTheme(context).copyDecorationWith(
      border: Border.all(color: Colors.red),
      borderRadius: BorderRadius.circular(15.r),
    );
  }
}
