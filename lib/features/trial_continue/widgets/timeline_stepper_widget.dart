import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

class TimelineStepperWidget extends StatelessWidget {

  final  String date3Days;
  const TimelineStepperWidget({super.key, required this.date3Days});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT SIDE — ICON + TIMELINE
        SizedBox(
          width: 40.w,
          child: Stack(
            children: [
              // Pink vertical line
              Positioned(
                left: 10.w,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 14.w,
                  decoration: BoxDecoration(
                    color: Color(0xFFFEADE5),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),

              // Column for icons (these will sit ON the line)
              Column(
                children: [
                  _circleIcon(Assets.icons.lock.path),
                  SizedBox(height: 80.h),

                  _circleIcon(Assets.icons.noti.path),
                  SizedBox(height: 80.h),

                  _circleIcon(Assets.icons.premiumIcon.path),
                ],
              ),
            ],
          ),
        ),

        SizedBox(width: 16.w),

        // RIGHT SIDE TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _stepText(
                "Today",
                "Unlock all the app's features like Ai calories scanning and more",
              ),

              UIHelper.verticalSpace(40.h),

              _stepText(
                "In 2 Days - Reminder",
                "We'll send you a reminder that your trial is ending soon",
              ),

              UIHelper.verticalSpace(40.h),

              _stepText(
                "In 3 Days - Billing Starts",
                "You'll be charged on $date3Days unless you cancel anytime before",
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Circle Icon Widget
  Widget _circleIcon(String icon) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE2448B),
      ),
      child: Image.asset(
        icon,
        width: 18.w,
        height: 18.h,
        fit: BoxFit.cover,
        color: Colors.white,
      ),
    );
  }

  // Text Block Widget
  Widget _stepText(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
        UIHelper.verticalSpace(8.h),
        Text(
          desc,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
