import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/common_widget/custom_network_image.dart';
import 'package:gritti_app/features/chef/widgets/food_calories_widget.dart';

import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/ui_helpers.dart';

class CaroselWidget extends StatelessWidget {
  final String title;
  final String foodCalories;

  final String minute;

  final String protein;

  final String image;

  final VoidCallback? onTap;

  const CaroselWidget({
    super.key,
    required this.title,
    required this.foodCalories,

    required this.minute,

    required this.protein,

    required this.image,

    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 370.h,
        width: 1.sw,
        child: Stack(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: CustomCachedNetworkImage(
                imageUrl: image,
                height: 370.h,
                width: 1.sw,
                fit: BoxFit.cover,
              ),
            ),

          // Gradient overlay at bottom for text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.85),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // title
          Positioned(
            bottom: 80.h,
            left: 16.w,
            right: 16.w,
            //   height: 16.h,
            child: Text(
              title,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          UIHelper.verticalSpace(16.h),

          Positioned(
            bottom: 20.h,
            left: 16.w,
            right: 16.w,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FoodCaloriesWidget(
                  icon: Assets.icons.firesSimple,
                  foodCalories: foodCalories,
                  title: 'kcal',
                ),

                FoodCaloriesWidget(
                  icon: Assets.icons.vectorww,
                  foodCalories: minute,
                  title: 'minuti',
                ),

                FoodCaloriesWidget(
                  icon: Assets.icons.protine,
                  foodCalories: protein,
                  title: 'Proteine',
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
