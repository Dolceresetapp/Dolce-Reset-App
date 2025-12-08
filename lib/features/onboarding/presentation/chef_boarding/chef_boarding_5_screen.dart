import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_app_bar.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../../common_widget/app_bar_widget2.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../networks/api_acess.dart';

class ChefBoardingScreen5 extends StatefulWidget {
  final String chefBoarding1;
  final String chefBoarding2;
  final String chefBoarding3;
  final String chefBoarding4;

  const ChefBoardingScreen5({
    super.key,
    required this.chefBoarding1,
    required this.chefBoarding2,
    required this.chefBoarding3,
    required this.chefBoarding4,
  });

  @override
  State<ChefBoardingScreen5> createState() => _ChefBoardingScreen5State();
}

class _ChefBoardingScreen5State extends State<ChefBoardingScreen5> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log("chefBoarding1====>> ${widget.chefBoarding1}");
    log("chefBoarding2====>> ${widget.chefBoarding2}");
    log("chefBoarding3====>> ${widget.chefBoarding3}");
    log("chefBoarding4====>> ${widget.chefBoarding4}");
    log("chefBoarding5====>> ${_controller.text.toString()}");
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget2(currentStep: 5),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(30.h),
            Text(
              "Do you have any food or ingredient that you don't lile ?",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 27.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(16.h),

            Text(
              "In you don't have intolerance just click on the button continue",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF52525B),
                fontSize: 16.sp,

                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(16.h),

            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: CustomTextField(
                controller: _controller,
                maxLines: 5,
                hintText: "Type your answer. \n (ex. Lactose , Gluten etc)",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "required filled";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            } else {
              bool isSuccess =
                  await chefRxObj
                      .chefRx(
                        goalsFor: widget.chefBoarding1,
                        dietaryPreferences: widget.chefBoarding2,
                        intolerancesa: widget.chefBoarding3,
                        activityLevel: widget.chefBoarding4,
                        dontLike: _controller.text.trim().toString(),
                      )
                      .waitingForFuture();

              if (isSuccess) {
                NavigationService.navigateToReplacement(Routes.greatJobScreen);
              }
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
