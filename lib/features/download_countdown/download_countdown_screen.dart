import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';

import '../../constants/text_font_style.dart';
import '../../gen/assets.gen.dart';
import '../../helpers/ui_helpers.dart';

class DownloadCountdownScreen extends StatefulWidget {
  const DownloadCountdownScreen({super.key});

  @override
  State<DownloadCountdownScreen> createState() =>
      _DownloadCountdownScreenState();
}

class _DownloadCountdownScreenState extends State<DownloadCountdownScreen> {
  int countdown = 3; // Start from 3
  String message = "Are you ready?";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 1) {
        // When countdown reaches 1 -> move to next screen
        timer.cancel();
        navigateToNextScreen();
      } else {
        setState(() {
           countdown--;
          updateMessage();
        });
      }
    });
  }

  void updateMessage() {
    switch (countdown) {
      case 3:
        message = "Are you ready?";
        break;
      case 2:
        message = "Just do your best";
        break;
      case 1:
        message = "Good luck!";
        break;
    }
  }

  void navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 1), () {
      NavigationService.navigateToReplacement(Routes.exerciseVideoScreen);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                countdown.toString(),
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: Color(0xFF000000),
                  fontSize: 150.h,
                  fontWeight: FontWeight.w400,
                ),
              ),

              UIHelper.verticalSpace(30.h),

              Text(
                message,
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: Color(0xFF52525B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: SvgPicture.asset(
          Assets.icons.logos,
          width: 165.w,
          height: 25.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
