import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/features/excerises/data/rx_get_category/model/category_response_model.dart';
import 'package:gritti_app/features/excerises/data/rx_get_theme/model/theme_response_model.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../common_widget/custom_network_image.dart';
import '../../../networks/api_acess.dart';
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

class _ExceriseScreenState extends State<ExceriseScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Trigger data fetch — cache interceptor returns instantly if data exists
    categoryRxObj.categoryRx();
    themeRxObj.themeRx();
    myWorkoutRxObj.myWorkoutRx();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SafeArea(
          child: Column(
            children: [
              ValueListenableBuilder<String>(
                valueListenable: avatarNotifier,
                builder: (_, avatar, __) => ProfileSectionWidget(avatar: avatar.isEmpty ? getUserAvatar() : avatar),
              ),
              UIHelper.verticalSpace(30.h),

              // Esercizi per Zona
              _SectionHeader(
                title: "Esercizi per Zona",
                onSeeAll: () => NavigationService.navigateToWithArgs(
                  Routes.exceriseSeeScreen,
                  {"categoryType": "body_part_exercise", "type": "all_category"},
                ),
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
                      if (snapshot.hasData &&
                          snapshot.data!.data != null &&
                          snapshot.data!.data!.isNotEmpty) {
                        final items = snapshot.data!.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          padding: EdgeInsets.zero,
                          itemExtent: 90.w,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (_, index) {
                            final data = items[index];
                            return _CategoryItem(data: data);
                          },
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(height: 115.h);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),

              UIHelper.verticalSpace(20.h),
              _SectionHeader(
                title: "Allenamenti a Tema",
                onSeeAll: () => NavigationService.navigateToWithArgs(
                  Routes.exceriseSeeScreen,
                  {"categoryType": "theme_workout", "type": "all_theme"},
                ),
              ),
              UIHelper.verticalSpace(20.h),

              // Theme grid
              StreamBuilder<ThemeResponseModel>(
                stream: themeRxObj.themeRxStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.data != null &&
                      snapshot.data!.data!.isNotEmpty) {
                    final items = snapshot.data!.data!;
                    final count = items.length > 4 ? 4 : items.length;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 158 / 131,
                      ),
                      itemCount: count,
                      itemBuilder: (context, index) {
                        final data = items[index];
                        return _ThemeItem(data: data);
                      },
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(height: 280.h);
                  }
                  return const SizedBox.shrink();
                },
              ),

              UIHelper.verticalSpace(20.h),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Livello Allenamento",
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
                      title: 'Principiante',
                      onTap: () => NavigationService.navigateToWithArgs(
                        Routes.dynamicWorkoutScreen,
                        {"type": "training_level", "levelType": "beginner"},
                      ),
                    ),
                    TrainingLevelCardWidget(
                      countIcon: 2,
                      icon: Assets.images.image1807.path,
                      title: 'Intermedio',
                      onTap: () => NavigationService.navigateToWithArgs(
                        Routes.dynamicWorkoutScreen,
                        {"type": "training_level", "levelType": "intermediate"},
                      ),
                    ),
                    TrainingLevelCardWidget(
                      countIcon: 3,
                      icon: Assets.images.image1807.path,
                      title: 'Avanzato',
                      onTap: () => NavigationService.navigateToWithArgs(
                        Routes.dynamicWorkoutScreen,
                        {"type": "training_level", "levelType": "advance"},
                      ),
                    ),
                  ],
                ),
              ),

              UIHelper.verticalSpace(16.h),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "I Miei Allenamenti",
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
                  if (snapshot.hasData &&
                      snapshot.data!.activeWorkouts != null &&
                      snapshot.data!.activeWorkouts!.isNotEmpty) {
                    final workouts = snapshot.data!.activeWorkouts!;
                    return ListView.builder(
                      itemCount: workouts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (_, index) {
                        final data = workouts[index];
                        return InkWell(
                          onTap: () => NavigationService.navigateToWithArgs(
                            Routes.readyScreen,
                            {"id": data.id},
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: ActiveWorkoutWidget(
                              image: data.image ?? "",
                              title: data.title ?? "",
                              kcal: data.calories.toString(),
                              time: data.minutes.toString(),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(height: 100.h);
                  }
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Text(
                        "Nessun allenamento attivo",
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
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

// Extracted stateless widgets for better rebuild performance

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF27272A),
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            "Vedi Tutto",
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              color: const Color(0xFFF97316),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final dynamic data;
  const _CategoryItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigationService.navigateToWithArgs(
        Routes.dynamicWorkoutScreen,
        {"type": "body_part_exercise", "id": data.id},
      ),
      child: Padding(
        padding: EdgeInsets.only(right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: CustomCachedNetworkImage(
                imageUrl: data.image ?? "",
                width: 70.w,
                height: 70.h,
                fit: BoxFit.fill,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            Text(
              data.name ?? "",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF2E2E2E),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelper.verticalSpace(4.h),
            Text(
              "${data.workOut ?? 0} Allenamenti",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF2E2E2E).withOpacity(0.4),
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeItem extends StatelessWidget {
  final dynamic data;
  const _ThemeItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigationService.navigateToWithArgs(
        Routes.dynamicWorkoutScreen,
        {"type": "theme_workout", "id": data.id},
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Stack(
          children: [
            CustomCachedNetworkImage(
              imageUrl: data.image ?? "",
              width: double.infinity,
              height: 131.h,
              fit: BoxFit.cover,
            ),
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
                    colors: [Colors.white, Colors.white, Color(0x00FFFFFF)],
                    stops: [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 18.h,
              left: 12.w,
              child: Text(
                data.name ?? "",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
