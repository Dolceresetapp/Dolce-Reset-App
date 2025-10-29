import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../gen/assets.gen.dart';

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({super.key});

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.images.womensBg.path),
          ),
        ),
      ),

      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        width: 1.sw,
        height: 0.6.sh,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Ready?",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 50.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            UIHelper.verticalSpace(16.h),

            Align(
              alignment: Alignment.center,
              child: Container(
                width: 0.45.sw,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: ShapeDecoration(
                  color: const Color(0xFF27272A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10.w,
                  children: [
                    Image.asset(
                      Assets.icons.clock.path,
                      width: 12.w,
                      height: 12.h,
                    ),

                    Text(
                      "10 min",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: Colors.white,
                            fontSize: 14.sp,

                            fontWeight: FontWeight.w500,
                          ),
                    ),

                    Image.asset(
                      Assets.icons.firePng.path,
                      width: 12.w,
                      height: 12.h,
                    ),
                    Text(
                      "87 Kcal",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: Colors.white,
                            fontSize: 14.sp,

                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          
            UIHelper.verticalSpace(24.h),

            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Row(
                    spacing: 10.w,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.asset(
                          Assets.images.biceps.path,
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Column(
                        spacing: 8.h,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Leg Circles",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(
                                  color: const Color(0xFF27272A),
                                  fontSize: 18.sp,

                                  fontWeight: FontWeight.w600,
                                ),
                          ),

                          Text(
                            "30 Seconds",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(
                                  color: const Color(0xFF27272A),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            UIHelper.verticalSpace(24.h),

            CustomButton(onPressed: () {
              NavigationService.navigateTo(Routes.downloadProgressScreen);
            }, text: "Start"),
          ],
        ),
      ),
    );
  }
}
