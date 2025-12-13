import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/common_widget/custom_network_image.dart';
import 'package:gritti_app/common_widget/waiting_widget.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/networks/api_acess.dart';

import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../barcode/data/model/scan_response_model.dart';
import 'data/model/meal_result_response_model.dart';

class MealResultScreen extends StatefulWidget {
  final ScanResonseModel response;
  const MealResultScreen({super.key, required this.response});

  @override
  State<MealResultScreen> createState() => _MealResultScreenState();
}

class _MealResultScreenState extends State<MealResultScreen> {
  @override
  void initState() {
    super.initState();

    mealResultRxObj.mealResultRx(
      name: widget.response.data?.name.toString() ?? "",
      brands: widget.response.data?.brands.toString() ?? "",
      energyKcal: widget.response.data?.nutriments?.energyKcal.toString() ?? "",
      fat: widget.response.data?.nutriments?.fat.toString() ?? "",
      saturatedFat:
          widget.response.data?.nutriments?.saturatedFat.toString() ?? "",
      carbohydrates:
          widget.response.data?.nutriments?.carbohydrates.toString() ?? "",
      sugars: widget.response.data?.nutriments?.sugars.toString() ?? "",
      fiber: widget.response.data?.nutriments?.fiber.toString() ?? "",
      proteins: widget.response.data?.nutriments?.proteins.toString() ?? "",
      salt: widget.response.data?.nutriments?.salt.toString() ?? "",
      image: widget.response.data?.image.toString() ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            NavigationService.goBack;
          },
          child: Padding(
            padding: EdgeInsets.all(14.sp),
            child: SvgPicture.asset(
              Assets.icons.icon,
              width: 20.w,
              height: 20.h,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Meal Result",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,

                fontWeight: FontWeight.w600,
              ),
            ),

            SvgPicture.asset(Assets.icons.infoCircle, width: 20.w, height: 20),
          ],
        ),
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),

        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: StreamBuilder<MealResponseModel>(
          stream: mealResultRxObj.mealResultRxStream,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return WaitingWidget();
            } else if (asyncSnapshot.hasData) {
              MealResponseModel? model = asyncSnapshot.data;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UIHelper.verticalSpace(50.h),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: SizedBox(
                      width: 100.w,
                      height: 80.h,
                      child: CustomCachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            model?.data?.image ??
                            "", // You can adjust the fit as needed
                      ),
                    ),
                  ),

                  UIHelper.verticalSpace(30.h),

                  Text(
                    "Product name : ${model?.data?.productName ?? ""}",
                    textAlign: TextAlign.start,
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,

                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  UIHelper.verticalSpace(8.h),

                  Text(
                    "Brand name : ${model?.data?.brand ?? ""}",
                    textAlign: TextAlign.start,
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,

                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  UIHelper.verticalSpace(8.h),

                  Text(
                    "Score : ${model?.data?.score ?? 0 / 100}",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,

                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  UIHelper.verticalSpace(8.h),
                  Text(
                    model?.data?.verdict ?? "",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,

                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  UIHelper.verticalSpace(8.h),
                  Text(
                    "Reason:${model?.data?.reason ?? ""}",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,

                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  UIHelper.verticalSpace(8.h),
                  Text(
                    "Details: ${model?.data?.details ?? ""}",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,

                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  UIHelper.verticalSpace(10.h),

                  // Row(
                  //   spacing: 10.w,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "In case here are some healthy options",
                  //       style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                  //           .copyWith(
                  //             color: const Color(0xFF27272A),
                  //             fontSize: 16.sp,

                  //             fontWeight: FontWeight.w700,
                  //           ),
                  //     ),

                  //     Text(
                  //       "See All",
                  //       style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                  //           .copyWith(
                  //             color: const Color(0xFF767EFF),
                  //             fontSize: 14.sp,

                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //     ),
                  //   ],
                  // ),
                  UIHelper.verticalSpace(30.h),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: model?.data?.alternatives?.length,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, index) {
                      var data = model?.data?.alternatives?[index];
                      return Container(
                        width: 1.sw,
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(12.sp),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFAFAFA),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.w,
                              color: const Color(0xFFE4E4E7),
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// LEFT CONTENT
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFD4D4D8),
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      "Category : ${data?.category ?? ""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextFontStyle
                                          .headLine16cFFFFFFWorkSansW600
                                          .copyWith(
                                            color: const Color(0xFF52525B),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),

                                  SizedBox(height: 8.h),

                                  Text(
                                    data?.name ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextFontStyle
                                        .headLine16cFFFFFFWorkSansW600
                                        .copyWith(
                                          color: const Color(0xFF27272A),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),

                                  SizedBox(height: 8.h),

                                  Text(
                                    data?.whyBetter ?? "",
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextFontStyle
                                        .headLine16cFFFFFFWorkSansW600
                                        .copyWith(
                                          color: const Color(0xFF27272A),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 16.w),

                            /// RIGHT IMAGE
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: CustomCachedNetworkImage(
                                  imageUrl: data?.imageUrl ?? "",
                                  height: 158.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  UIHelper.verticalSpace(20.h),

                  CustomButton(
                    onPressed: () {
                      NavigationService.navigateTo(Routes.navigationScreen);
                    },
                    child: Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                        ),

                        SvgPicture.asset(Assets.icons.rightArrows),
                      ],
                    ),
                  ),

                  UIHelper.verticalSpaceSemiLarge,
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
