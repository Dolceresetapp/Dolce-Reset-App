import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/helpers/toast.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:signature/signature.dart';

import '../../../common_widget/custom_button.dart';
import '../../../common_widget/custom_svg_asset.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/di.dart';
import '../../../helpers/navigation_service.dart';

class OnboardingScreen17 extends StatefulWidget {
  const OnboardingScreen17({super.key});

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
                  "Firma il tuo impegno",
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
                  "Infine, prometti a te stessa che inizierai a mangiare meglio e muoverti di pi\u00f9 per essere sana e in forma",
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
                    "Cancella",
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
              ToastUtil.showShortToast("Firma prima di continuare");
              return;
            }

            // Save signature as base64 to GetStorage
            appData.write(
              kKeyPendingSignature,
              base64Encode(signatureBytes),
            );

            // Navigate to plan summary
            NavigationService.navigateToReplacement(
              Routes.planReadyScreen,
            );
          },
          child: Text(
            "Continua",
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
          ),
        ),
      ),
    );
  }
}
