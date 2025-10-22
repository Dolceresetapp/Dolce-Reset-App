import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_app_bar.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import '../../../../common_widget/app_bar_widget.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/navigation_service.dart';

class ChefBoardingScreen5 extends StatefulWidget {
  const ChefBoardingScreen5({super.key});

  @override
  State<ChefBoardingScreen5> createState() => _ChefBoardingScreen5State();
}

class _ChefBoardingScreen5State extends State<ChefBoardingScreen5> {
  List<Map<String, dynamic>> dataList = [
    {"image": Assets.images.losttWeight.path, "title": "Lose Weight"},

    {"image": Assets.images.intoShape.path, "title": "Get back into shape"},

    {"image": Assets.images.slep.path, "title": "Improve sleep/energy"},

    {"image": Assets.images.reducePain.path, "title": "Reduce pain/stiffness"},
  ];

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 5, isBackIcon: true, maxSteps: 5),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),
            Text(
              "Do you have any specific intolerances ?",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 27.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(16.h),

            Text(
              "In you don’t have intolerance just click on the button continue",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF52525B),
                fontSize: 16.sp,

                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(16.h),

            CustomTextField(
              controller: _controller,
              maxLines: 5,
              hintText: "Type your answer. \n (ex. Lactose , Gluten etc)",
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () {
            NavigationService.navigateTo(Routes.greatJobScreen);
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
