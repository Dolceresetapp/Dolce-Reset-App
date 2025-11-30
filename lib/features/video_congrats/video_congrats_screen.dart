import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../common_widget/custom_button.dart';
import '../../helpers/navigation_service.dart';

class VideoCongratsScreen extends StatefulWidget {
  final int duration;
  final int kcal;
  const VideoCongratsScreen({
    super.key,
    required this.duration,
    required this.kcal,
  });

  @override
  State<VideoCongratsScreen> createState() => _VideoCongratsScreenState();
}

class _VideoCongratsScreenState extends State<VideoCongratsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UIHelper.verticalSpace(20.h),
              Image.asset(
                Assets.images.likeIcon.path,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.contain,
              ),

              UIHelper.verticalSpace(20.h),

              Text(
                "Congrats",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 30.sp,
                ),
              ),

              UIHelper.verticalSpace(20.h),

              Text(
                "You completed Full Body \n Tone 15-Min Sculpt",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: Colors.grey.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),

              UIHelper.verticalSpace(20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIcon(
                    icon: Assets.images.watchicon.path,
                    title: widget.duration.toString(),
                    subtitle: "Minute",
                  ),
                  _buildIcon(
                    icon: Assets.images.frameBellIcon.path,
                    title: widget.kcal.toString(),
                    subtitle: "kcal",
                  ),
                ],
              ),

              UIHelper.verticalSpace(30.h),

              CustomButton(
                onPressed: () {
                  NavigationService.navigateToReplacement(
                    Routes.navigationScreen,
                  );
                },
                child: Row(
                  spacing: 10.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue",
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
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildIcon({
  required String icon,
  required String title,
  required String subtitle,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Image.asset(Assets.images.watchicon.path, width: 70.w, height: 70.h),

      Text(
        title,
        style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 30.sp,
        ),
      ),

      Text(
        subtitle,
        style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600.copyWith(
          color: Colors.black,
        ),
      ),
    ],
  );
}
