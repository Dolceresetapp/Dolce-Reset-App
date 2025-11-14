import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../gen/assets.gen.dart';
import 'custom_svg_asset.dart';

class AppBarWidget2 extends StatelessWidget {
  final int currentStep;


  final bool isBackIcon;

  const AppBarWidget2({
    super.key,
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
              child: InkWell(
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
            )
            : Expanded(flex: 1, child: SizedBox()),

        Expanded(
          flex: 3,
          child: LinearProgressBar(
            minHeight: 10.h,
            maxSteps: 5,
            progressType: LinearProgressBar.progressTypeLinear,
            currentStep: currentStep,
            progressColor: Color(0xFFF566A9),
            backgroundColor: Color(0xFFE4E4E7),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),

        Expanded(flex: 1, child: Text("")),
      ],
    );
  }
}
