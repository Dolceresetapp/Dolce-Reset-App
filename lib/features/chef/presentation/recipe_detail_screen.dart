import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_network_image.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../data/model/ai_receipe_response_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final AiReceipeResponseData recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero image with app bar
          SliverAppBar(
            expandedHeight: 280.h,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () {
                NavigationService.navigateToReplacementWithObject(
                  Routes.navigationScreen,
                  {"index": 1}, // Chef screen
                );
              },
              child: Container(
                margin: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: SvgPicture.asset(
                    Assets.icons.icon,
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: CustomCachedNetworkImage(
                imageUrl: recipe.imageUrl ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.meal ?? "Ricetta",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  UIHelper.verticalSpace(16.h),

                  // Stats row with dark text
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          icon: Assets.icons.firesSimple,
                          value: "${recipe.calories ?? 0}",
                          label: "kcal",
                        ),
                        Container(
                          width: 1,
                          height: 40.h,
                          color: const Color(0xFFE0E0E0),
                        ),
                        _buildStatItem(
                          icon: Assets.icons.vectorww,
                          value: "${recipe.timeMin ?? 0}",
                          label: "minuti",
                        ),
                        Container(
                          width: 1,
                          height: 40.h,
                          color: const Color(0xFFE0E0E0),
                        ),
                        _buildStatItem(
                          icon: Assets.icons.protine,
                          value: "${recipe.proteinG ?? 0}g",
                          label: "proteine",
                        ),
                      ],
                    ),
                  ),

                  UIHelper.verticalSpace(24.h),

                  // Description
                  if (recipe.description != null && recipe.description!.isNotEmpty) ...[
                    Text(
                      "Descrizione",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFF27272A),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    Text(
                      recipe.description!,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFF52525B),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                    UIHelper.verticalSpace(24.h),
                  ],

                  // Ingredients
                  if (recipe.ingredients != null && recipe.ingredients!.isNotEmpty) ...[
                    Text(
                      "Ingredienti",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFF27272A),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFE4E4E7),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recipe.ingredients!.map((ingredient) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 6.h),
                                  width: 6.w,
                                  height: 6.h,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF566A9),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    ingredient,
                                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                                      color: const Color(0xFF52525B),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    UIHelper.verticalSpace(24.h),
                  ],

                  // Steps
                  if (recipe.steps != null && recipe.steps!.isNotEmpty) ...[
                    Text(
                      "Preparazione",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFF27272A),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    ...recipe.steps!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFE4E4E7),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28.w,
                              height: 28.h,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF566A9),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                step,
                                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                                  color: const Color(0xFF52525B),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  // Empty state if no ingredients/steps
                  if ((recipe.ingredients == null || recipe.ingredients!.isEmpty) &&
                      (recipe.steps == null || recipe.steps!.isEmpty)) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.sp),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F5),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 40.sp,
                            color: const Color(0xFFF566A9),
                          ),
                          UIHelper.verticalSpace(12.h),
                          Text(
                            "Ricetta in Evidenza",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                              color: const Color(0xFFF566A9),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          UIHelper.verticalSpace(8.h),
                          Text(
                            "Genera una nuova ricetta con l'AI per ottenere ingredienti e istruzioni dettagliate.",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                              color: const Color(0xFF52525B),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],

                  UIHelper.verticalSpaceMediumLarge,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              height: 18.h,
              width: 18.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFF27272A),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              value,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF71717A),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
