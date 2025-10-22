import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:image_picker/image_picker.dart';

class FoodAnalyzerScreen extends StatefulWidget {
  const FoodAnalyzerScreen({super.key});

  @override
  State<FoodAnalyzerScreen> createState() => _FoodAnalyzerScreenState();
}

class _FoodAnalyzerScreenState extends State<FoodAnalyzerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(Assets.icons.icon, width: 20.w, height: 20.h),

            Text(
              "Food Analyzer Scanner",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,

                fontWeight: FontWeight.w600,
              ),
            ),

            SvgPicture.asset(Assets.icons.ques, width: 20.w, height: 20),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            UIHelper.verticalSpace(50.h),

            Image.asset(
              Assets.images.food.path,
              width: double.infinity,
              height: 200.h,
            ),

            UIHelper.verticalSpace(45.h),

            Text(
              "Check your food is \n healthy or not!",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 30.sp,

                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(30.h),

            Text(
              "Scan the barcode on the packaging of your food",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: Colors.black,
                fontSize: 12.sp,

                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(30.h),

            CustomButton(
              onPressed: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? ImageFile = await imagePicker.pickImage(
                  source: ImageSource.camera,
                );

                if (ImageFile != null) {
                  NavigationService.navigateTo(Routes.mealResultScreen);
                }

              
              },
              child: Row(
                spacing: 10.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.icons.camera),

                  Text(
                    "Scan with AI",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
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
