import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../widgets/active_workout_widget.dart';
import '../widgets/profile_section_widget.dart';
import '../widgets/training_level_card_widget.dart';

class ExceriseScreen extends StatefulWidget {
  const ExceriseScreen({super.key});

  @override
  State<ExceriseScreen> createState() => _ExceriseScreenState();
}

class _ExceriseScreenState extends State<ExceriseScreen> {
  final searchControler = TextEditingController();

  @override
  void dispose() {
    searchControler.dispose();
    super.dispose();
  }

  // Body Parts Excerise List
  List<Map<String, dynamic>> bodyPartsList = [
    {"icon": Assets.images.leg.path, "title": "Leg"},
    {"icon": Assets.images.shoulders.path, "title": "Shoulders"},
    {"icon": Assets.images.biceps.path, "title": "Biceps"},
    {"icon": Assets.images.abs.path, "title": "Abs"},
  ];

  // Theme Workout List
  List<Map<String, dynamic>> workoutThemeList = [
    {"icon": Assets.images.rectangle34624225.path, "title": "Wall \n pilates"},
    {"icon": Assets.images.rectangle34624226.path, "title": "Mat \n pilates"},
    {"icon": Assets.images.rectangle34624229.path, "title": "Full \n Body"},
    {"icon": Assets.images.rectangle34624227.path, "title": "Bed \n workout"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),

        child: SafeArea(
          child: Column(
            children: [
              ProfileSectionWidget(),
              UIHelper.verticalSpace(8.h),

              CustomTextField(
                controller: searchControler,
                prefixIcon: Assets.icons.icon1,
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
                  Text(
                    "See All",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFFF97316),
                      fontSize: 14.sp,

                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpace(20.h),

              SizedBox(
                height: 100.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: bodyPartsList.length,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    var data = bodyPartsList[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Column(
                        spacing: 10.h,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              data["icon"],
                              width: 70.w,
                              height: 70.h,
                              fit: BoxFit.fill,
                            ),
                          ),

                          Text(
                            data["title"],
                            textAlign: TextAlign.center,
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(
                                  color: const Color(0xFF2E2E2E),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
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
                  Text(
                    "See All",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFFF97316),
                      fontSize: 14.sp,

                      fontWeight: FontWeight.w500,
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
                              style: TextFontStyle.headLine16cFFFFFFWorkSansW600
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

              ActiveWorkoutWidget(
                icon: Assets.images.abs.path,
                title: "Pushups For Beginners & Beyond",
                text: "Upper Body",
                time: "20 min",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
