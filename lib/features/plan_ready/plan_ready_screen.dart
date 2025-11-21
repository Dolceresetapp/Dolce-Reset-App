import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../common_widget/custom_button.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';

class PlanReadyScreen extends StatefulWidget {
  const PlanReadyScreen({super.key});

  @override
  State<PlanReadyScreen> createState() => _PlanReadyScreenState();
}

class _PlanReadyScreenState extends State<PlanReadyScreen> {
  CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UIHelper.verticalSpace(20.h),
              Text(
                "Your personalized 30- \n day plan is ready!",
                textAlign: TextAlign.center,
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF000000),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              UIHelper.verticalSpace(16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE5F1),

                  borderRadius: BorderRadius.circular(15.r),
                ),

                child: Text(
                  "Scientifically designed for your goals",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600
                      .copyWith(
                        color: const Color(0xFF000000),
                        fontSize: 14.sp,
                      ),
                ),
              ),

              UIHelper.verticalSpace(10.h),

              SizedBox(
                width: 1.sw,
                height: 250.h,
                child: Image.asset(
                  Assets.images.imageCopy.path,

                  fit: BoxFit.fitWidth,
                ),
              ),

              CarouselSlider.builder(
                itemCount: 3,
                carouselController: carouselController,
                itemBuilder: (context, index, realIndex) {
                  return Image.asset(
                    Assets.images.group.path,
                    width: 1.sw,
                    fit: BoxFit.fitWidth,
                  );
                },

                options: CarouselOptions(
                  height: 300.h,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  enlargeFactor: 0.5,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),

              UIHelper.verticalSpace(20.h),

              CustomButton(
                onPressed: () {
                  NavigationService.navigateTo(Routes.customPlanReadyScreen);
                },
                child: Row(
                  spacing: 10.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Start the plan with 3 days  free",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                    ),

                    SvgPicture.asset(
                      Assets.icons.rightArrows,
                      width: 20.w,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                    UIHelper.verticalSpace(20.h),
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
