import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/features/excerises/data/rx_get_category/model/category_response_model.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../common_widget/custom_network_image.dart';
import '../../../common_widget/waiting_widget.dart';
import '../../../networks/api_acess.dart';
import '../../common_widget/custom_svg_asset.dart';
import '../../helpers/all_routes.dart';
import '../excerises/data/rx_post_theme/model/category_wise_theme_response_model.dart';

class ExceriseSeeScreen extends StatefulWidget {
  String? categoryType;

  int? categoryId;

  String? type;

  String? trainingLevel;
  ExceriseSeeScreen({
    super.key,
    this.categoryType,
    this.categoryId,
    this.trainingLevel,

    this.type,
  });

  @override
  State<ExceriseSeeScreen> createState() => _ExceriseSeeScreenState();
}

class _ExceriseSeeScreenState extends State<ExceriseSeeScreen> {
  final searchControler = TextEditingController();

  @override
  void dispose() {
    searchControler.dispose();
    categoryRxObj.categoryRx();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // When User click see all then this api will call to fetch all category
    if (widget.categoryType == "body_part_exercise" &&
        widget.type == "all_category") {
      log("======================================All Category Called");
      categoryRxObj.categoryRx();
    } else if (widget.categoryId != null &&
        widget.type == "category_id_base_theme") {
      log("======================================Category Id Called");
      categoryWiseThemeRxObj.categoryWiseThemeRx(categoryId: widget.categoryId);
    } else if (widget.categoryType == "theme_workout" &&
        widget.type == "all_theme") {
      log("=====================================All Theme Workout Called");
      // All theme workout
      categoryWiseThemeRxObj.categoryWiseThemeRx();
    } else if (widget.trainingLevel != null &&
        widget.trainingLevel == "Beginner" &&
        widget.type == "beginner_level") {
      log("=====================================Beginner raining Level Called");
      categoryWiseThemeRxObj.categoryWiseThemeRx(type: "beginner");
    } else if (widget.trainingLevel != null &&
        widget.trainingLevel == "Intermediate" &&
        widget.type == "intermediate_level") {
      log(
        "=====================================Intermediate Training Level Called",
      );
      categoryWiseThemeRxObj.categoryWiseThemeRx(type: "intermediate");
    } else if (widget.trainingLevel != null &&
        widget.trainingLevel == "Advance" &&
        widget.type == "advance_level") {
      log("=====================================Advance Training Level Called");
      categoryWiseThemeRxObj.categoryWiseThemeRx(type: "advance");
    }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      NavigationService.goBack;
                    },
                    child: CustomSvgAsset(
                      width: 20.w,
                      height: 20.h,
                      color: Color(0xFF27272A),
                      fit: BoxFit.contain,
                      assetName: Assets.icons.icon,
                    ),
                  ),

                  Expanded(child: SvgPicture.asset(Assets.icons.logos)),
                ],
              ),

              UIHelper.verticalSpace(20.h),

              CustomTextField(
                controller: searchControler,
                prefixIcon: Assets.icons.icon1,
                hintText: "Search for a workout...",

                onFieldSubmitted: (value) {
                  if (widget.categoryType == "body_part_exercise") {
                    categoryRxObj.categoryRx(search: value).waitingForFuture();
                    searchControler.clear();
                  } else if (widget.categoryType == "theme_workout") {
                    categoryWiseThemeRxObj
                        .categoryWiseThemeRx(
                          categoryId: widget.categoryId,
                          search: value,
                        )
                        .waitingForFuture();
                    searchControler.clear();
                  }
                },
              ),

              UIHelper.verticalSpace(16.h),

              //
              //
              //
              //
              //
              //
              //Body parts Exercise
              widget.categoryType == "body_part_exercise"
                  ? Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Body parts Exercise",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: const Color(0xFF27272A),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  )
                  : SizedBox.shrink(),

              widget.categoryType == "body_part_exercise"
                  ? UIHelper.verticalSpace(20.h)
                  : SizedBox.shrink(),

              widget.categoryType == "body_part_exercise"
                  ? StreamBuilder<CategoryResponseModel>(
                    stream: categoryRxObj.categoryRxStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: WaitingWidget());
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
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h,
                                childAspectRatio: 70 / 96,
                              ),
                          itemCount: model?.data?.length,
                          itemBuilder: (context, index) {
                            var data = model?.data?[index];

                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 4,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: InkWell(
                                    onTap: () {
                                      NavigationService.navigateToWithArgs(
                                        Routes.exceriseSeeScreen,
                                        {
                                          "categoryType": "theme_workout",
                                          "categoryId": data?.id,
                                          "type": "category_id_base_theme",
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 20.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                  color: const Color(
                                                    0xFF2E2E2E,
                                                  ),
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
                                                  ).withValues(alpha: 0.4),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w300,
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
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  )
                  : SizedBox.shrink(),

              //
              //
              //
              //
              //
              //
              //
              //
              //Theme Workout.
              widget.categoryType == "theme_workout"
                  ? Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Theme Workout",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: const Color(0xFF27272A),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  )
                  : SizedBox.shrink(),
              UIHelper.verticalSpace(20.h),

              widget.categoryType == "theme_workout"
                  ? StreamBuilder<CategoryWiseThemeResponseModel>(
                    stream: categoryWiseThemeRxObj.categoryWiseThemeRxStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: WaitingWidget());
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
                            "Theme \n not availabe",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(
                                  color: const Color(0xFFF97316),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        CategoryWiseThemeResponseModel? model = snapshot.data;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h,
                                childAspectRatio: 158 / 131,
                              ),
                          itemCount: model?.data?.length,
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
                                      log(
                                        "=====================================Theme Taped me",
                                      );
                                      NavigationService.navigateToWithArgs(
                                        Routes.videoScreen,
                                        {"themeId": data?.id},
                                      );
                                    },

                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            15.r,
                                          ),
                                          child: CustomCachedNetworkImage(
                                            imageUrl: data?.image ?? "",
                                            width: double.infinity,
                                            height: 131.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),

                                        Positioned(
                                          bottom: 10.h,
                                          left: 10.w,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 20.h,
                                              left: 10.w,
                                            ),
                                            child: Text(
                                              data?.name ?? "",
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  )
                  : SizedBox.shrink(),

              UIHelper.verticalSpaceSemiLarge,
            ],
          ),
        ),
      ),
    );
  }
}
