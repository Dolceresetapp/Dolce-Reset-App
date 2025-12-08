import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';

class TextReceiverWidget extends StatelessWidget {
  final String message;
  const TextReceiverWidget({super.key, required this.message});

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




// Container(
//         width: 0.5.sw,
//         alignment: Alignment.topLeft,
//         height: 400.h,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(Assets.images.container.path),
//           ),
//         ),
//       ),