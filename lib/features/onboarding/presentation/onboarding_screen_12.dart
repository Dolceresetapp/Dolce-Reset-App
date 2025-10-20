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

class OnboardingScreen12 extends StatefulWidget {
  const OnboardingScreen12({super.key});

  @override
  State<OnboardingScreen12> createState() => _OnboardingScreen12State();
}

class _OnboardingScreen12State extends State<OnboardingScreen12> {
  List<Map<String, dynamic>> dataList = [
    {
      "image": Assets.images.noboard121.path,
      "title": "May proveto",
      "subtitle": "It's my first attempt",
    },

    {
      "image": Assets.images.noboard122.path,
      "title": "A few months",
      "subtitle": "I just started",
    },

    {
      "image": Assets.images.noboard123.path,
      "title": "Years",
      "subtitle": "Problem that has been present for years",
    },
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 12, isBackIcon: true, maxSteps : 15),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),
            Text(
              "Did you find solutions to solve your problem?",
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
                  subtitle: data["subtitle"],
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
            NavigationService.navigateTo(Routes.onboardingScreen13);
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
