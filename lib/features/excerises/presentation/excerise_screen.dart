import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/features/excerises/data/rx_get_category/model/category_response_model.dart';
import 'package:gritti_app/features/excerises/data/rx_get_theme/model/theme_response_model.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../common_widget/custom_network_image.dart';
import '../../../common_widget/waiting_widget.dart';
import '../../../constants/app_constants.dart';
import '../../../helpers/di.dart';
import '../../../networks/api_acess.dart';
import '../../../services/image_preloader_service.dart';
import '../data/rx_get_my_workout/model/my_workout_response_model.dart';
import '../widgets/active_workout_widget.dart';
import '../widgets/profile_section_widget.dart';
import '../widgets/training_level_card_widget.dart';
import '../../../helpers/helper_methods.dart';

class ExceriseScreen extends StatefulWidget {
  const ExceriseScreen({super.key});

  @override
  State<ExceriseScreen> createState() => _ExceriseScreenState();
}

class _ExceriseScreenState extends State<ExceriseScreen> {
  StreamSubscription? _categorySub;
  StreamSubscription? _themeSub;
  StreamSubscription? _workoutSub;

  @override
  void initState() {
    super.initState();
    // Le cache Dio retourne les données instantanément si elles existent
    categoryRxObj.categoryRx();
    themeRxObj.themeRx();
    myWorkoutRxObj.myWorkoutRx();

    // Preload images when data arrives
    _categorySub = categoryRxObj.categoryRxStream.listen((data) {
      if (data.data != null) {
        final urls = data.data!.map((e) => e.image ?? '').where((url) => url.isNotEmpty).toList();
        imagePreloader.preloadImages(urls, firstBatchSize: 6);
      }
    });

    _themeSub = themeRxObj.themeRxStream.listen((data) {
      if (data.data != null) {
        final urls = data.data!.map((e) => e.image ?? '').where((url) => url.isNotEmpty).toList();
        imagePreloader.preloadImages(urls, firstBatchSize: 4);
      }
    });

    _workoutSub = myWorkoutRxObj.myWorkoutRxStream.listen((data) {
      if (data.activeWorkouts != null) {
        final urls = data.activeWorkouts!.map((e) => e.image ?? '').where((url) => url.isNotEmpty).toList();
        imagePreloader.preloadImages(urls, firstBatchSize: 3);
      }
    });
  }

  @override
  void dispose() {
    _categorySub?.cancel();
    _themeSub?.cancel();
    _workoutSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,

      //   // Center Logo
      //   title: SvgPicture.asset(
      //     Assets.icons.logos,
      //     fit: BoxFit.contain,
      //     height: 28.h,
      //   ),

      //   // Left Profile Image
      //   leading: Padding(
      //     padding: EdgeInsets.only(left: 16.w),
      //     child: ClipOval(
      //       child: SizedBox(
      //         width: 32.w,
      //         height: 32.w,
      //         child: CustomCachedNetworkImage(
      //           imageUrl: "https://your-image-url.com",
      //           fit: BoxFit.cover,
      //           width: 40.w,
      //           height: 32.w,
      //         ),
      //       ),
      //     ),
      //   ),

      //   // Right Notification Icon
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.only(right: 16.w),
      //       child: SvgPicture.asset(
      //         Assets.icons.icoddn, // notification icon
      //         height: 24.h,
      //         width: 24.w,
      //       ),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),

        child: SafeArea(
          child: Column(
            children: [
              //   UIHelper.verticalSpace(10.h),
              ProfileSectionWidget(avatar: getUserAvatar()),
              UIHelper.verticalSpace(30.h),

              // Body parts Exercise
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
                        {
                          "categoryType": "body_part_exercise",
                          "type": "all_category",
                        },
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

              // Category List
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 115.h,
                  child: StreamBuilder<CategoryResponseModel>(
                    stream: categoryRxObj.categoryRxStream,
                    builder: (context, snapshot) {
                      // Show data first if available (from cache), even while loading
                      if (snapshot.hasData && snapshot.data!.data != null && snapshot.data!.data!.isNotEmpty) {
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
                                NavigationService.navigateToWithArgs(
                                  Routes.dynamicWorkoutScreen,
                                  {
                                    "type": "body_part_exercise",
                                    "id": data?.id,
                                  },
                                );
                              },

                              child: Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: Column(
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

                                    UIHelper.verticalSpace(8.h),

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

                                    UIHelper.verticalSpace(4.h),
                                    Text(
                                      // (data?.workOut == null ||
                                      //         data!.workOut == 0)
                                      //     ? ""
                                      //     :
                                      "${data?.workOut ?? 0} Workouts",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextFontStyle
                                          .headLine16cFFFFFFWorkSansW600
                                          .copyWith(
                                            color: const Color(
                                              0xFF2E2E2E,
                                            ).withOpacity(0.4),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(height: 115.h); // Empty space while loading, no spinner
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
                        {"categoryType": "theme_workout", "type": "all_theme"},
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

              /// Theme
              StreamBuilder<ThemeResponseModel>(
                stream: themeRxObj.themeRxStream,
                builder: (context, snapshot) {
                  // Show data first if available (from cache)
                  if (snapshot.hasData && snapshot.data!.data != null && snapshot.data!.data!.isNotEmpty) {
                    ThemeResponseModel? model = snapshot.data;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 158 / 131,
                      ),
                      itemCount:
                          (model?.data?.length ?? 0) > 4
                              ? 4
                              : (model?.data?.length ?? 0),

                      itemBuilder: (context, index) {
                        var data = model?.data?[index];

                        return AnimationConfiguration.staggeredGrid(
                          position: 2,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: InkWell(
                                onTap: () {
                                  NavigationService.navigateToWithArgs(
                                    Routes.dynamicWorkoutScreen,
                                    {"type": "theme_workout", "id": data?.id},
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Stack(
                                    children: [
                                      // Image
                                      CustomCachedNetworkImage(
                                        imageUrl: data?.image ?? "",
                                        width: double.infinity,
                                        height: 131.h,
                                        fit: BoxFit.cover,
                                      ),

                                      // White gradient overlay
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          height: 80.h,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.white,
                                                Colors.white,
                                                Color(0x00FFFFFF),
                                              ],
                                              stops: [0.0, 0.45, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Theme Name
                                      Positioned(
                                        bottom: 18.h,
                                        left: 12.w,
                                        child: Text(
                                          data?.name ?? "",
                                          style: TextFontStyle
                                              .headLine16cFFFFFFWorkSansW600
                                              .copyWith(
                                                color: const Color(0xFF27272A),
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(height: 280.h); // Empty space while loading
                  } else {
                    return SizedBox.shrink();
                  }
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
                      onTap: () {
                        NavigationService.navigateToWithArgs(
                          Routes.dynamicWorkoutScreen,
                          {"type": "training_level", "levelType": "beginner"},
                        );
                      },
                    ),
                    // beginner,advance,intermediate
                    TrainingLevelCardWidget(
                      countIcon: 2,
                      icon: Assets.images.image1807.path,
                      title: 'Intermediate',
                      onTap: () {
                        NavigationService.navigateToWithArgs(
                          Routes.dynamicWorkoutScreen,
                          {
                            "type": "training_level",
                            "levelType": "intermediate",
                          },
                        );
                      },
                    ),

                    TrainingLevelCardWidget(
                      countIcon: 3,
                      icon: Assets.images.image1807.path,
                      title: 'Advance',
                      onTap: () {
                        NavigationService.navigateToWithArgs(
                          Routes.dynamicWorkoutScreen,
                          {"type": "training_level", "levelType": "advance"},
                        );
                      },
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

              StreamBuilder<MyWorkoutResponseModel>(
                stream: myWorkoutRxObj.myWorkoutRxStream,
                builder: (context, snapshot) {
                  // Show data first if available (from cache)
                  if (snapshot.hasData && snapshot.data!.activeWorkouts != null && snapshot.data!.activeWorkouts!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data?.activeWorkouts?.length,

                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),

                      padding: EdgeInsets.zero,

                      itemBuilder: (_, index) {
                        var data = snapshot.data?.activeWorkouts?[index];
                        return InkWell(
                          onTap: () {
                            NavigationService.navigateToWithArgs(
                              Routes.readyScreen,
                              {"id": data?.id},
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: ActiveWorkoutWidget(
                              image: data?.image ?? "",
                              title: data?.title ?? "",
                              kcal: data?.calories.toString() ?? "",
                              time: data?.minutes.toString() ?? "",
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(height: 100.h); // Empty space while loading
                  } else {
                    // No workouts yet
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          "No active workouts yet",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    );
                  }
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
