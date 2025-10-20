import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

class MealResultScreen extends StatefulWidget {
  const MealResultScreen({super.key});

  @override
  State<MealResultScreen> createState() => _MealResultScreenState();
}

class _MealResultScreenState extends State<MealResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(Assets.icons.icon, width: 20.w, height: 20.h),

            Text(
              "Meal Result",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,

                fontWeight: FontWeight.w600,
              ),
            ),

            SvgPicture.asset(Assets.icons.infoCircle, width: 20.w, height: 20),
          ],
        ),
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),

        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            UIHelper.verticalSpace(50.h),

            ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: SizedBox(
                width: 100.w,
                height: 80.h,
                child: Image.asset(
                  Assets.images.fooodddd.path,
                  fit: BoxFit.cover, // You can adjust the fit as needed
                ),
              ),
            ),

            UIHelper.verticalSpace(30.h),

            Text(
              "83 / 100",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,

                fontWeight: FontWeight.w800,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            Text(
              "Yes, is healthy !",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 30.sp,

                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(10.h),

            Row(
              spacing: 10.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "In case here are some healthy options",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 16.sp,

                    fontWeight: FontWeight.w700,
                  ),
                ),

                Text(
                  "See All",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF767EFF),
                    fontSize: 14.sp,

                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            UIHelper.verticalSpace(30.h),

            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                return Container(
                  width: 1.sw, 
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.sp),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFAFAFA),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.w,
                        color: const Color(0xFFE4E4E7),
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        spacing: 20.h,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.w,
                                  color: const Color(0xFFD4D4D8),
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "Low Callorie",
                              style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                  .copyWith(
                                    color: const Color(0xFF52525B),
                                    fontSize: 12.sp,

                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),

                          Text(
                            "Oat flakes",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(
                                  color: const Color(0xFF27272A),
                                  fontSize: 16.sp,

                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),

                      Expanded(
                        child: Image.asset(
                          Assets.images.images232.path,
                          width: 138.w,
                          height: 158.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            UIHelper.verticalSpace(20.h),

            CustomButton(
              onPressed: () {
                //       NavigationService.navigateTo(Routes.mealResultScreen);
              },
              child: Row(
                spacing: 10.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Continue",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                  ),

                  SvgPicture.asset(Assets.icons.rightArrows),
                ],
              ),
            ),

            UIHelper.verticalSpaceMediumLarge,
          ],
        ),
      ),
    );
  }
}
