import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import '../../common_widget/custom_app_bar.dart';
import '../../constants/text_font_style.dart';
import '../../gen/assets.gen.dart';
import '../../helpers/ui_helpers.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';

class DownloadProgressScreen extends StatefulWidget {
  const DownloadProgressScreen({super.key});

  @override
  State<DownloadProgressScreen> createState() => _DownloadProgressScreenState();
}

class _DownloadProgressScreenState extends State<DownloadProgressScreen> {
  Timer? timer;
  int currentStep = 0; // start at 0
  final int maxSteps = 6; // total duration (6 seconds)

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentStep >= maxSteps) {
        timer.cancel();
        navigateToNextScreen();
      } else {
        setState(() {
          currentStep++; // increase progress every second
        });
      }
    });
  }

  void navigateToNextScreen() {
    NavigationService.navigateToReplacement(Routes.downloadCountdownScreen);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Assets.icons.downloadProgress.path,
                width: 38.w,
                height: 38.h,
                fit: BoxFit.cover,
              ),

              UIHelper.verticalSpace(60.h),

              Text(
                "Download in progress...",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF52525B),
                  fontWeight: FontWeight.w400,
                  fontSize: 18.sp,
                ),
              ),

              UIHelper.verticalSpace(60.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.2.sw),
                child: LinearProgressBar(
                  maxSteps: maxSteps,
                  progressType: LinearProgressBar.progressTypeLinear,
                  currentStep: currentStep,
                  progressColor: const Color(0xFFF566A9),
                  backgroundColor: const Color(0xFFE4E4E7),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              UIHelper.verticalSpace(20.h),

              Text(
                "${(currentStep / maxSteps * 100).toStringAsFixed(0)}%",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF52525B),
                  fontWeight: FontWeight.w500,
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
