import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/features/chef/widgets/food_calories_widget.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

class CaroselWidget extends StatelessWidget {
  final String title;
  final String foodCalories;

  const CaroselWidget({
    super.key,
    required this.title,
    required this.foodCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 370.h,
      width: 1.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        image: DecorationImage(
          image: AssetImage(Assets.images.image22.path),
          fit: BoxFit.cover,
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
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
          UIHelper.verticalSpace(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FoodCaloriesWidget(
                icon: Assets.icons.firesSimple,
                foodCalories: foodCalories,
                title: 'kcal',
              ),
              FoodCaloriesWidget(
                icon: Assets.icons.vectorww,
                foodCalories: foodCalories,
                title: 'minutes',
              ),
              FoodCaloriesWidget(
                icon: Assets.icons.firesSimple,
                foodCalories: foodCalories,
                title: 'Protein',
              ),
            ],
          ),

          UIHelper.verticalSpaceMedium,
        ],
      ),
    );
  }
}
