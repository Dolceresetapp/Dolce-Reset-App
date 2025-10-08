import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_app_bar.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../common_widget/app_bar_widget.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../widgets/tile_card_widget.dart';

class OnboardingScreen4 extends StatefulWidget {
  const OnboardingScreen4({super.key});

  @override
  State<OnboardingScreen4> createState() => _OnboardingScreen4State();
}

class _OnboardingScreen4State extends State<OnboardingScreen4> {
  List<Map<String, dynamic>> dataList = [
    {"image": Assets.images.onboard41.path, "title": "Slender"},

    {"image": Assets.images.onboard42.path, "title": "In the media"},

    {"image": Assets.images.onboard43.path, "title": "strong cuts"},
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 4, isBackIcon: true),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),
            Text(
              "How do you describe your body?",
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
            NavigationService.navigateToReplacement(Routes.onboardingScreen5);
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
                Assets.icons.vector1,
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
