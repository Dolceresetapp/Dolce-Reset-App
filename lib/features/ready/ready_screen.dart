import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../gen/assets.gen.dart';

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({super.key});

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  @override
  void initState() {
    super.initState();
  }

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
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.r),
            bottomRight: Radius.circular(10.r),
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

            Container(
              //         alignment: Alignment(x, y),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: ShapeDecoration(
                color: const Color(0xFF27272A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Row(
                spacing: 10.w,
                children: [
                  Image.asset(
                    Assets.icons.clock.path,
                    width: 12.w,
                    height: 12.h,
                  ),

                  Text(
                    "10 min",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
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
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,

                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
  // com.dolceresetltd.app
            UIHelper.verticalSpace(24.h),

            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 3,

              itemBuilder: (_, index) {
                return Row(
                  spacing: 10.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.r),
                      child: Image.asset(
                        Assets.images.biceps.path,
                        width: 120.w,
                        height: 70.h,
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
