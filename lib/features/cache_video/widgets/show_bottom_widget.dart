import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/helpers/navigation_service.dart';

import '../../../common_widget/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../networks/api_acess.dart';

class ShowBottomWidget extends StatelessWidget {
  final int totalCal;
  final String duration; // Format: "M:SS"
  final int listId;
  final Future<void> Function()? onStopAll;
  const ShowBottomWidget({
    super.key,
    required this.totalCal,
    required this.duration,
    required this.listId,
    this.onStopAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag bar
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          SizedBox(height: 20.h),

          // Title
          Text(
            'Tieni duro!\nCe la puoi fare!',
            textAlign: TextAlign.center,
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 20.sp,
              height: 1.3,
            ),
          ),

          SizedBox(height: 24.h),

          // Continue button
          CustomButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              spacing: 10.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Continua allenamento",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                ),
                SvgPicture.asset(
                  Assets.icons.arrowRight,
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Finish button
          CustomButton(
            color: const Color(0xFFAE47FF),
            onPressed: () {
              // Stop all video/audio in background
              onStopAll?.call();

              // Save in background (don't wait, no loading)
              activeWorkoutSaveRxObj
                  .activeWorkoutSaveRx(listId: listId)
                  .catchError((_) => false);

              // Navigate immediately
              NavigationService.navigateToWithArgs(
                Routes.videoCongratsScreen,
                {"duration": duration, "kcal": totalCal},
              );
            },
            text: "Termina allenamento",
          ),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
