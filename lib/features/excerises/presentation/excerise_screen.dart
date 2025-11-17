import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/features/excerises/data/rx_get_category/model/category_response_model.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../common_widget/custom_network_image.dart';
import '../../../common_widget/waiting_widget.dart';
import '../../../networks/api_acess.dart';
import '../widgets/active_workout_widget.dart';
import '../widgets/profile_section_widget.dart';
import '../widgets/training_level_card_widget.dart';

class ExceriseScreen extends StatefulWidget {
  const ExceriseScreen({super.key});

  @override
  State<ExceriseScreen> createState() => _ExceriseScreenState();
}

class _ExceriseScreenState extends State<ExceriseScreen> {
  // Theme Workout List
  List<Map<String, dynamic>> workoutThemeList = [
    {"icon": Assets.images.rectangle34624225.path, "title": "Wall \n pilates"},
    {"icon": Assets.images.rectangle34624226.path, "title": "Mat \n pilates"},
    {"icon": Assets.images.rectangle34624229.path, "title": "Full \n Body"},
    {"icon": Assets.images.rectangle34624227.path, "title": "Bed \n workout"},
  ];

  @override
  void initState() {
    super.initState();

    categoryRxObj.categoryRx();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),

        child: SafeArea(
          child: Column(
            children: [
              UIHelper.verticalSpace(10.h),
              ProfileSectionWidget(avatar: '',),
              UIHelper.verticalSpace(20.h),

              CustomTextField(
                prefixIcon: Assets.icons.icon1,
                readOnly: true,
                hintText: "Search for a workout...",
              ),

              UIHelper.verticalSpace(16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Body parts Exercise",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigateToWithArgs(
                        Routes.exceriseSeeScreen,
                        {"categoryType": "body_part_exercise"},
                      );
                    },
                    child: Text(
                      "See All",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: const Color(0xFFF97316),
                            fontSize: 14.sp,

                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpace(20.h),

              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 100.h,
                  child: StreamBuilder<CategoryResponseModel>(
                    stream: categoryRxObj.categoryRxStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return WaitingWidget();
                      } else if (snapshot.hasError) {
                        return Text(
                          "someting went wrong",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: const Color(0xFFF97316),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                              ),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "Category data \n not availabe",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(
                                  color: const Color(0xFFF97316),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        CategoryResponseModel? model = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: model?.data?.length,
                          padding: EdgeInsets.zero,

                          physics: ClampingScrollPhysics(),
                          itemBuilder: (_, index) {
                            var data = model?.data?[index];
                            return InkWell(
                              onTap: () {
                                categoryWiseThemeRxObj
                                    .categoryWiseThemeRx(categoryId: data?.id!)
                                    .waitingForFuture()
                                    .then((success) {
                                      if (success) {
                                        NavigationService.navigateToWithArgs(
                                          Routes.exceriseSeeScreen,
                                          {"categoryType": "theme_workout"},
                                        );
                                      }
                                    });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: Column(
                                  spacing: 10.h,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: CustomCachedNetworkImage(
                                        imageUrl: data?.image ?? "",
                                        width: 70.w,
                                        height: 70.h,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    Text(
                                      data?.name ?? "",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextFontStyle
                                          .headLine16cFFFFFFWorkSansW600
                                          .copyWith(
                                            color: const Color(0xFF2E2E2E),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),

              UIHelper.verticalSpace(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Theme Workout",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigateToWithArgs(
                        Routes.exceriseSeeScreen,
                        {"categoryType": "theme_workout"},
                      );
                    },
                    child: Text(
                      "See All",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: const Color(0xFFF97316),
                            fontSize: 14.sp,

                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(20.h),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 158 / 131,
                ),
                itemCount: workoutThemeList.length,
                itemBuilder: (context, index) {
                  var data = workoutThemeList[index];

                  return AnimationConfiguration.staggeredGrid(
                    position: 2,
                    duration: const Duration(milliseconds: 500),
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: InkWell(
                          onTap: () {
                            NavigationService.navigateTo(Routes.videoScreen);
                          },
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(data["icon"]),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20, left: 10.w),
                              child: Text(
                                data["title"],
                                style: TextFontStyle
                                    .headLine16cFFFFFFWorkSansW600
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              UIHelper.verticalSpace(20.h),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Training Level",
                  textAlign: TextAlign.start,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              UIHelper.verticalSpace(20.h),

              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TrainingLevelCardWidget(
                      countIcon: 1,
                      icon: Assets.images.image1807.path,
                      title: 'Beginner',
                    ),

                    TrainingLevelCardWidget(
                      countIcon: 2,
                      icon: Assets.images.image1807.path,
                      title: 'Intermediate',
                    ),

                    TrainingLevelCardWidget(
                      countIcon: 3,
                      icon: Assets.images.image1807.path,
                      title: 'Advance',
                    ),
                  ],
                ),
              ),

              UIHelper.verticalSpace(16.h),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "My Active Workout",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              UIHelper.verticalSpace(16.h),

              ListView.builder(
                itemCount: 10,

                shrinkWrap: true,

                padding: EdgeInsets.zero,

                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      NavigationService.navigateTo(Routes.videoScreen);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: ActiveWorkoutWidget(
                        icon: Assets.images.abs.path,
                        title: "Pushups For Beginners & Beyond",
                        text: "Upper Body",
                        time: "20 min",
                      ),
                    ),
                  );
                },
              ),

              UIHelper.verticalSpaceSemiLarge,
            ],
          ),
        ),
      ),
    );
  }
}
