import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_app_bar.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../../common_widget/app_bar_widget2.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../helpers/toast.dart';
import '../../widgets/tile_card_widget.dart';

class ChefBoardingScreen2 extends StatefulWidget {
  final String chefBoarding1;
  const ChefBoardingScreen2({super.key, required this.chefBoarding1});

  @override
  State<ChefBoardingScreen2> createState() => _ChefBoardingScreen2State();
}

class _ChefBoardingScreen2State extends State<ChefBoardingScreen2> {
  List<Map<String, dynamic>> dataList = [
    {
      "image": Assets.images.losttWeight.path,
      "title": "Omnivore (you eat everything)",
    },

    {"image": Assets.images.vegetian.path, "title": "Vegetarian"},

    {"image": Assets.images.veg.path, "title": "Vegan"},

    {"image": Assets.images.pes.path, "title": "Pescatarian"},

    {"image": Assets.images.car.path, "title": "Carnivore"},
  ];

  int? selectedIndex;
  String? selectedText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget2(currentStep: 2),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),
            Text(
              "Did you feel it was \n necessary to immediately \n repair your body?",
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
                        selectedText = data["title"];
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
            if (selectedIndex == null) {
              ToastUtil.showErrorShortToast("Please select an item.");
            } else {
              NavigationService.navigateToWithArgs(Routes.chefBoardingScreen3, {
                "chefBoarding1": widget.chefBoarding1,
                "chefBoarding2": selectedText,
              });
            }
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
