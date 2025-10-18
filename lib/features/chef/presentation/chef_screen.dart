import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../common_widget/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../widgets/ai_card_widget.dart';
import '../widgets/carosel_widget.dart';

class ChefScreen extends StatefulWidget {
  const ChefScreen({super.key});

  @override
  State<ChefScreen> createState() => _ChefScreenState();
}

class _ChefScreenState extends State<ChefScreen> {
  CarouselSliderController carouselController = CarouselSliderController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),

        padding: EdgeInsets.symmetric(horizontal: 16.w),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.verticalSpace(20.h),
              Text(
                "Browse Meals",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 30.sp,

                  fontWeight: FontWeight.w700,
                ),
              ),

              UIHelper.verticalSpace(10.h),
              Text(
                "Explore and log curated meals from us",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF52525B),
                  fontSize: 16.sp,

                  fontWeight: FontWeight.w400,
                ),
              ),

              UIHelper.verticalSpace(30.h),

              CustomButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "panic Button",
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

              UIHelper.verticalSpace(20.h),

              Row(
                spacing: 16.w,
                children: [
                  Expanded(
                    child: AiCardWidget(
                      image: Assets.images.rectangle34624174.path,
                      onTap: () {
                        NavigationService.navigateTo(Routes.forgetOtpScreen);
                      },
                    ),
                  ),

                  Expanded(
                    child: AiCardWidget(
                      image: Assets.images.rectangle346241741.path,
                      onTap: () {
                        NavigationService.navigateTo(Routes.forgetOtpScreen);
                      },
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpace(30.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Featured Meal",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text(
                    "See All",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF767EFF),
                      fontSize: 14.sp,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpace(12.h),

              CarouselSlider.builder(
                itemCount: 3,
                carouselController: carouselController,

                itemBuilder: (context, index, realIndex) {
                  return CaroselWidget(
                    title: "Scrambled Eggs with Mashed Avocado & Lentils",
                    foodCalories: "125",
                  );
                },

                options: CarouselOptions(
                  height: 370.h,
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
                  enlargeFactor: 0.3,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),

              UIHelper.verticalSpace(16.h),

              Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8.h,
                    dotWidth: 8.w,
                    activeDotColor: Color(0xFFF566A9),
                    dotColor: Color(0xFFDFE1E1),
                  ),
                ),
              ),

              UIHelper.verticalSpaceMediumLarge,
            ],
          ),
        ),
      ),
    );
  }
}
