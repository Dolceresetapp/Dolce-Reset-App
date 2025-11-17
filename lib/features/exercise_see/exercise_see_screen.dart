import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';

import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/features/excerises/data/rx_get_category/model/category_response_model.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import '../../../common_widget/custom_network_image.dart';
import '../../../common_widget/waiting_widget.dart';
import '../../../networks/api_acess.dart';
import '../../common_widget/custom_svg_asset.dart';


class ExceriseSeeScreen extends StatefulWidget {
  final String categoryType;
  const ExceriseSeeScreen({super.key, required this.categoryType});

  @override
  State<ExceriseSeeScreen> createState() => _ExceriseSeeScreenState();
}

class _ExceriseSeeScreenState extends State<ExceriseSeeScreen> {
  final searchControler = TextEditingController();

  @override
  void dispose() {
    searchControler.dispose();
    super.dispose();
  }

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
                                      // NavigationService.navigateTo(
                                      //   Routes.videoScreen,
                                      // );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 20.w),
                                      child: Column(
                                        spacing: 10.h,
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
                  ? GridView.builder(
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
                                NavigationService.navigateTo(
                                  Routes.videoScreen,
                                );
                              },
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(data["icon"]),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 20,
                                    left: 10.w,
                                  ),
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
