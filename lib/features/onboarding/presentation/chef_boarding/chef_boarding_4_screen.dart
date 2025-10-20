import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_app_bar.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../../common_widget/app_bar_widget.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/navigation_service.dart';
import '../../widgets/tile_card_widget.dart';

class ChefBoardingScreen4 extends StatefulWidget {
  const ChefBoardingScreen4({super.key});

  @override
  State<ChefBoardingScreen4> createState() => _ChefBoardingScreen4State();
}

class _ChefBoardingScreen4State extends State<ChefBoardingScreen4> {
  List<Map<String, dynamic>> dataList = [
    {"image": Assets.images.losttWeight.path, "title": "Lose Weight"},

    {"image": Assets.images.intoShape.path, "title": "Get back into shape"},

    {"image": Assets.images.slep.path, "title": "Improve sleep/energy"},

    {"image": Assets.images.reducePain.path, "title": "Reduce pain/stiffness"},
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 4, isBackIcon: true, maxSteps: 5),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),
            Text(
              "What’s your activity level ",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 27.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(30.h),

            ListView.builder(
              itemCount: dataList.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                var data = dataList[index];
                bool isChecked = selectedIndex == index;
                return TileCardWidget(
                  isSubtitle: false,
                  icon: data["image"],
                  isChecked: isChecked,
                  title: data["title"],
                  onChanged: (value) {
                    setState(() {
                      if (selectedIndex == index) {
                        selectedIndex = null;
                      } else {
                        selectedIndex = index;
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () {
            NavigationService.navigateTo(Routes.chefBoardingScreen5);
          },
          child: Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Continue",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
              ),

              SvgPicture.asset(
                Assets.icons.rightArrows,
                width: 20.w,
                height: 20.h,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
