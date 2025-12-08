import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/common_widget/waiting_widget.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../provider/chef_provider.dart';
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChefProvider>(context, listen: false).fetchData();
    });
  }

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

              UIHelper.verticalSpace(20.h),

              Row(
                spacing: 16.w,
                children: [
                  Expanded(
                    child: AiCardWidget(
                      title: "AI Recipe \n Generator",
                      image: Assets.images.rectangle34624174.path,
                      onTap: () {
                        if (appData.read(kKeyIsNutration) == 0) {
                          NavigationService.navigateTo(
                            Routes.chefBoardingScreen1,
                          );
                        } else {
                          NavigationService.navigateTo(
                            Routes.aiReceipeGeneratorScreen,
                          );
                        }
                      },
                    ),
                  ),

                  Expanded(
                    child: AiCardWidget(
                      title: "Food Health \n Analyzer",
                      image: Assets.images.rectangle346241741.path,
                      onTap: () {
                        NavigationService.navigateTo(Routes.foodAnalyzerScreen);
                      },
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpace(30.h),

              Text(
                "Featured Meal",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Featured Meal",
              //       style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              //         color: const Color(0xFF27272A),
              //         fontWeight: FontWeight.w700,
              //       ),
              //     ),

              //     Text(
              //       "See All",
              //       style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              //         color: const Color(0xFF767EFF),
              //         fontSize: 14.sp,

              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ],
              // ),
              UIHelper.verticalSpace(12.h),

              Consumer<ChefProvider>(
                builder: (context, provider, child) {
                  // Loading
                  if (provider.isLoading) {
                    return WaitingWidget();
                  }
                  // Error
                  else if (provider.error != null) {
                    return Text(
                      provider.error!,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(color: Colors.black),
                    );
                  }
                  // aiReceipeList is Null
                  else if (provider.aiReceipeList == null) {
                    return Text(
                      "No data found.",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(color: Colors.black),
                    );
                  } else if (provider.aiReceipeList!.isEmpty) {
                    return Text(
                      "Recipes meal haven't any data",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(color: Colors.black),
                    );
                  } else if (provider.aiReceipeList!.isEmpty) {
                    return Text("Recipes meal havn't any data");
                  } else {
                    return CarouselSlider.builder(
                      itemCount: provider.aiReceipeList!.length,
                      carouselController: carouselController,

                      itemBuilder: (context, index, realIndex) {
                        final item = provider.aiReceipeList![index];
                        return CaroselWidget(
                          image: item.imageUrl ?? "",
                          title: item.meal ?? "",
                          foodCalories: item.calories.toString(),
                          minute: item.timeMin.toString(),
                          protein: item.proteinG.toString(),
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
                    );
                  }
                },
              ),

              UIHelper.verticalSpace(16.h),

              Consumer<ChefProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading || provider.aiReceipeList == null) {
                    return SizedBox.shrink();
                  }
                  return Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: _currentIndex,
                      count: provider.aiReceipeList!.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8.h,
                        dotWidth: 8.w,
                        activeDotColor: Color(0xFFF566A9),
                        dotColor: Color(0xFFDFE1E1),
                      ),
                    ),
                  );
                },
              ),

              UIHelper.verticalSpaceMediumLarge,
            ],
          ),
        ),
      ),
    );
  }
}
