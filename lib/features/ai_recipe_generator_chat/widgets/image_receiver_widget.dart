import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/common_widget/custom_network_image.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';

class ImageReceiverWidget extends StatelessWidget {
  final String image;
  final String title;
  final String time;
  final String kcal;
  final String protine;
  final List<String> ingredientsData;
  final List<String> stepData;

  const ImageReceiverWidget({
    super.key,
    required this.image,
    required this.title,
    required this.time,
    required this.kcal,
    required this.protine,
    required this.ingredientsData,
    required this.stepData,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFAFAFA),
          boxShadow: [
            BoxShadow(color: Colors.orange),

            BoxShadow(color: Colors.red),
          ],

          borderRadius: BorderRadius.circular(8.r),
        ),

        padding: EdgeInsets.all(16.sp),
        width: 0.7.sw,
        alignment: Alignment.topLeft,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(8.r),
              child: CustomCachedNetworkImage(
                imageUrl: image,
                width: 0.7.sw,
                height: 0.15.sh,
                fit: BoxFit.fill,
              ),
            ),

            UIHelper.verticalSpace(10.h),

            // Title
            Text(
              title,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,

                fontWeight: FontWeight.w600,
              ),
            ),

            UIHelper.verticalSpace(10.h),

            FittedBox(
              child: Row(
                spacing: 8.w,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    spacing: 4.h,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        Assets.icons.timer.path,
                        height: 20.h,
                        width: 20.w,
                      ),
                      Text(
                        time,
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                            .copyWith(
                              color: const Color(0xFF27272A),
                              fontSize: 16.sp,

                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        Assets.icons.span.path,
                        height: 20.h,
                        width: 20.w,
                      ),
                      Text(
                        kcal,
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                            .copyWith(
                              color: const Color(0xFF27272A),
                              fontSize: 16.sp,

                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        Assets.icons.handle.path,
                        height: 20.h,
                        width: 20.w,
                      ),
                      Text(
                        protine,
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                            .copyWith(
                              color: const Color(0xFF27272A),
                              fontSize: 16.sp,

                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            UIHelper.verticalSpace(20.h),

            Text(
              "Ingredients",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            UIHelper.verticalSpace(8.h),
            ...ingredientsData.map(
              (item) => Text(
                item,
                style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                ),
              ),
            ),

            UIHelper.verticalSpace(20.h),

            Text(
              "Steps",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,

                fontWeight: FontWeight.w600,
              ),
            ),

            UIHelper.verticalSpace(8.h),

            ...stepData.map(
              (item) => Text(
                item,
                style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
