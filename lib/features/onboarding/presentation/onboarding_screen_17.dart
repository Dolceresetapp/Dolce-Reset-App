import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/helpers/toast.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import '../../../common_widget/custom_button.dart';
import '../../../common_widget/custom_svg_asset.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/di.dart';
import '../../../helpers/loading_helper.dart';
import '../../../helpers/navigation_service.dart';
import '../../../networks/api_acess.dart';

class OnboardingScreen17 extends StatefulWidget {
  final String onboard1;
  final String onboard2;
  final String onboard4;
  final String onboard5;
  final int onboard7HeightValue;
  final String onboard7HeightUnit;

  final double onboard8WeightValue;
  final String onboard8WeightUnit;

  final double onboard9TargetWeightValue;
  final String onboard9TargetWeightUnit;

  final DateTime selectedDate;

  final double bmi;

  final String onboard12;

  final String onboard13;

  final String onboard15;

  const OnboardingScreen17({
    super.key,
    required this.onboard1,
    required this.onboard2,
    required this.onboard4,
    required this.onboard5,
    required this.onboard7HeightValue,
    required this.onboard7HeightUnit,

    required this.onboard8WeightUnit,
    required this.onboard8WeightValue,

    required this.onboard9TargetWeightValue,
    required this.onboard9TargetWeightUnit,

    required this.selectedDate,

    required this.bmi,

    required this.onboard12,

    required this.onboard13,

    required this.onboard15,
  });

  @override
  State<OnboardingScreen17> createState() => _OnboardingScreen17State();
}

class _OnboardingScreen17State extends State<OnboardingScreen17> {
  final SignatureController _controller = SignatureController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("onboard1 ====== ${widget.onboard1}");
    log("onboard2 ====== ${widget.onboard2}");
    log("onboard4 ====== ${widget.onboard4}");
    log("onboard5 ====== ${widget.onboard5}");
    log("onboard7HeightValue ====== ${widget.onboard7HeightValue}");
    log("onboard7HeightUnit ====== ${widget.onboard7HeightUnit}");
    log("onboard8WeightValue ====== ${widget.onboard8WeightValue}");
    log("onboard8WeightUnit ====== ${widget.onboard8WeightUnit}");
    log("onboard9TargetWeightValue ====== ${widget.onboard9TargetWeightValue}");
    log("onboard9TargetWeightUnit ====== ${widget.onboard9TargetWeightUnit}");
    log("selectedDate ====== ${widget.selectedDate}");
    log("onboard12 ====== ${widget.onboard12}");
    log("onboard13 ====== ${widget.onboard13}");
    log("onboard15 ====== ${widget.onboard15}");

    log("ID : ${appData.read(kKeyID)}");

    log("ID  Type: ${appData.read(kKeyID).runtimeType}");

    log(
      "ID string type  : ${appData.read(kKeyID).toString().runtimeType.toString()}",
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  NavigationService.goBack;
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CustomSvgAsset(
                    width: 20.w,
                    height: 20.h,
                    color: Color(0xFF27272A),
                    fit: BoxFit.contain,
                    assetName: Assets.icons.icon,
                  ),
                ),
              ),
              UIHelper.verticalSpace(40.h),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Sign your commitment",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    fontSize: 20.sp,
                    color: Colors.black,
                  ),
                ),
              ),

              UIHelper.verticalSpace(20.h),

              Align(
                alignment: Alignment.center,
                child: Text(
                  "Finally, promise yourself that you will start to eat better and move more in order to be healthy and fit",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              UIHelper.verticalSpace(20.h),

              Container(
                width: double.infinity,
                height: 250.h,

                decoration: BoxDecoration(
                  color: Colors.white,

                  border: Border.all(color: Color(0xFFD9D9D9), width: 1.w),

                  borderRadius: BorderRadius.circular(20.r),
                ),

                child: Signature(
                  controller: _controller,
                  width: 300,
                  height: 300,
                  backgroundColor: Colors.transparent,
                ),
              ),

              UIHelper.verticalSpace(10.h),

              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    _controller.clear();
                  },
                  child: Text(
                    "Clear",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              UIHelper.verticalSpace(20.h),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () async {
            Uint8List? signatureBytes = await _controller.toPngBytes();
            if (signatureBytes == null) {
              ToastUtil.showErrorShortToast("Please sign before submitting");
              return;
            }

            log(DateFormat('yyyy-MM-dd').format(widget.selectedDate));

            onboardingRxObj
                .onboardingRx(
                  userId: appData.read(kKeyID).toString(),
                  age: DateFormat('yyyy-MM-dd').format(widget.selectedDate),
                  bmi: widget.bmi.toString(),
                  bodyPartFocus: widget.onboard2, // 84
                  bodySatisfaction: widget.onboard15, // 97

                  celebrationPlan: widget.onboard13, // 95
                  currentBodyType: widget.onboard4, // 86
                  currentWeight: widget.onboard8WeightValue.toString(), // 90
                  dreamBody: widget.onboard5, // 87
                  height: widget.onboard7HeightValue.toString(), // 89
                  targetWeight:
                      widget.onboard9TargetWeightValue.toString(), // 91
                  tryingDuration: widget.onboard12, // 94
                  urgentImprovement: widget.onboard1, // 83
                  signature: signatureBytes,
                  heightIn: widget.onboard7HeightUnit.toString(), // 89
                  targetWeightIn:
                      widget.onboard9TargetWeightUnit.toString(), // 91
                  weightIn: widget.onboard8WeightUnit.toString(), // 90
                )
                .waitingForFuture()
                .then((success) {
                  if (success) {
                    ToastUtil.showShortToast("User info saved successfully");
                    NavigationService.navigateToReplacement(
                      Routes.ratingScreen,
                    );

                    appData.write(kKeyIsOnboarding, false);
                  }
                });
          },
          child: Text(
            "Finish",
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
          ),
        ),
      ),
    );
  }
}
