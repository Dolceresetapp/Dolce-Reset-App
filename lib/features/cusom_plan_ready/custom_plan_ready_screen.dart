import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:intl/intl.dart';

import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';

class CustomPlanReadyScreen extends StatefulWidget {
  const CustomPlanReadyScreen({super.key});

  @override
  State<CustomPlanReadyScreen> createState() => _CustomPlanReadyScreenState();
}

class _CustomPlanReadyScreenState extends State<CustomPlanReadyScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime lastDay = today.add(const Duration(days: 30));

    String formattedDate = DateFormat('d MMMM yyyy').format(lastDay);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: BouncingScrollPhysics(),

        child: SafeArea(
          child: Column(
            children: [
              UIHelper.verticalSpace(10.h),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "${appData.read(kKeyName)} , we have a custom plan \n ready for you ! Are you Ready?",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: Color(0xFF8359F6),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              UIHelper.verticalSpace(10.h),

              Text(
                "You Will Start Feeling Better by: ",
                style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600.copyWith(
                  color: Color(0xFF000000),
                  fontSize: 20.sp,
                ),
              ),

              UIHelper.verticalSpace(30.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Color(0xFFAF185D),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  "$formattedDate \n 30 days after acutal day",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // InkWell(
              //   onTap: () {
              //
              //   },
              //   child: Image.asset(
              //     Assets.images.button.path,
              //     height: 65.h,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              UIHelper.verticalSpace(20.h),
              Image.asset(
                Assets.images.on1Copy.path,
                width: 1.sw,
                fit: BoxFit.cover,
              ),

              Image.asset(
                Assets.images.on2Copy.path,
                width: 1.sw,
                fit: BoxFit.cover,
              ),

              // Button
              InkWell(
                onTap: () {
                  NavigationService.navigateTo(Routes.rewiringBenefitScreen);
                },
                child: Image.asset(
                  Assets.images.button1111.path,
                  width: 1.sw,
                  fit: BoxFit.cover,
                ),
              ),

              Image.asset(
                Assets.images.on3Copy.path,
                width: 1.sw,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
