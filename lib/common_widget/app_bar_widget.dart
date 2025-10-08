import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../constants/text_font_style.dart';
import '../gen/assets.gen.dart';
import 'custom_svg_asset.dart';

class AppBarWidget extends StatelessWidget {
  final int maxSteps;
  final int currentStep;
  final bool isBackIcon;

  const AppBarWidget({
    super.key,
    required this.maxSteps,
    required this.currentStep,
    this.isBackIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isBackIcon
            ? Expanded(
              flex: 1,
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
            )
            : Expanded(flex: 1, child: SizedBox()),

        //    SizedBox.shrink(),
        Expanded(
          flex: 3,
          child: LinearProgressBar(
            minHeight: 10.h,
            maxSteps: maxSteps,
            progressType: LinearProgressBar.progressTypeLinear,
            currentStep: currentStep,
            progressColor: Color(0xFFF566A9),
            backgroundColor: Color(0xFFE4E4E7),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              // NavigationService.navigateTo(Routes)
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                'Skip',
                style: TextFontStyle.headline30c27272AtyleWorkSansW700.copyWith(
                  color: const Color(0xFFF566A9),
                  fontSize: 16,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
