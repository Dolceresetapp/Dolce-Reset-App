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
import '../excerises/data/rx_get_theme/model/theme_response_model.dart';

class ExceriseSeeScreen extends StatefulWidget {
  String? categoryType;

  String? type;

  String? trainingLevel;
  ExceriseSeeScreen({
    super.key,
    this.categoryType,

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
    categoryRxObj.categoryRx();
    themeRxObj.themeRx();
    searchControler.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                  } else if (widget.categoryType == "theme_workout") {
                    themeRxObj.themeRx(search: value).waitingForFuture();
                  }
                },
                // WHEN USER CLEARS THE SEARCH BOX → FETCH AGAIN
                onChanged: (value) {
                  if (value.isEmpty) {
                    if (widget.categoryType == "body_part_exercise") {
                      categoryRxObj.categoryRx();
                    } else if (widget.categoryType == "theme_workout") {
                      themeRxObj.themeRx();
                    }
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
                        return Center(
                          child: Text(
                            "Caricamento...",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          "Errore di connessione",
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
                            "Nessuna categoria disponibile",
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
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.w,
                                mainAxisSpacing: 8.h,
                                childAspectRatio: 70 / 100,
                              ),
                          itemCount: model?.data?.length,
                          itemBuilder: (context, index) {
                            var data = model?.data?[index];

                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 3,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: InkWell(
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
                                      padding: EdgeInsets.only(right: 16.w),
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
                                                  ).withOpacity(0.4),
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
                  ? StreamBuilder<ThemeResponseModel>(
                    stream: themeRxObj.themeRxStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text(
                            "Caricamento...",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          "Errore di connessione",
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
                            "Nessun tema disponibile",
                            textAlign: TextAlign.center,
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(
                                  color: const Color(0xFFF97316),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        ThemeResponseModel? model = snapshot.data;
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
                                      NavigationService.navigateToWithArgs(
                                        Routes.dynamicWorkoutScreen,
                                        {
                                          "type": "theme_workout",
                                          "id": data?.id,
                                        },
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
