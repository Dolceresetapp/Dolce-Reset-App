import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';

class ReceiverCoachWidget extends StatelessWidget {
  final String message;
  const ReceiverCoachWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        message,
        style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
          color: const Color(0xFF27272A),
          fontSize: 16.sp,

          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
