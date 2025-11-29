import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common_widget/custom_svg_asset.dart';
import '../../constants/text_font_style.dart';
import '../../gen/assets.gen.dart';
import '../../helpers/navigation_service.dart';

class ProgressBarWidget extends StatelessWidget {

  final VoidCallback onTap;
  const ProgressBarWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20.w,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Icon
        InkWell(
          onTap: () {
            NavigationService.goBack;
          },
          child: Align(
            alignment: Alignment.topLeft,
            child: CustomSvgAsset(
              width: 20.w,
              height: 20.h,
              color: Color(0xFF27272A),
              fit: BoxFit.contain,
              assetName: Assets.icons.icon,
            ),
          ),
        ),

        // Expanded(
        //   child: ProgressBar(
        //     thumbColor: Color(0xFFF566A9),
        //     progress: Duration(milliseconds: 1000),
        //     buffered: Duration(milliseconds: 2000),
        //     total: Duration(milliseconds: 5000),
        //     onSeek: (duration) {
        //       print('User selected a new time: $duration');
        //     },
        //   ),
        // ),
        InkWell(
          onTap: onTap,
          child: Text(
            "Done",
            style: TextFontStyle.headline30c27272AtyleWorkSansW700.copyWith(
              fontSize: 16.sp,
              color: Color(0xFFF566A9),
            ),
          ),
        ),
      ],
    );
  }

  
}
