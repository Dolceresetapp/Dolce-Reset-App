import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.image.path),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Title
                UIHelper.verticalSpace(10.h),
                Text(
                  "Motivation",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    fontSize: 16.sp,
                  ),
                ),

                // Center Text & Icons
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Hey Emma!\nBe stronger than\nyour excuses",
                          textAlign: TextAlign.center,
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        UIHelper.verticalSpace(56.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.icons.buttonIcon1,
                              width: 80.w,
                              height: 80.h,
                            ),

                            UIHelper.horizontalSpace(20.w),

                            SvgPicture.asset(
                              Assets.icons.buttonIcon2,
                              width: 80.w,
                              height: 80.h,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Button
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: CustomButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "join community Now",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(fontSize: 16.sp),
                        ),

                        UIHelper.horizontalSpace(10.w),
                        SvgPicture.asset(
                          Assets.icons.arrowRight,
                          width: 20.w,
                          height: 20.h,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
