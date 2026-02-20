import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_app_bar.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/di.dart';

import '../../../common_widget/app_bar_widget.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/ui_helpers.dart';

class OnboardingScreen16 extends StatefulWidget {
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

  const OnboardingScreen16({
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
  State<OnboardingScreen16> createState() => _OnboardingScreen16State();
}

class _OnboardingScreen16State extends State<OnboardingScreen16> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: AppBarWidget(currentStep: 13),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UIHelper.verticalSpace(40.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Prova Gratis 3 Giorni! \n Vedi Se Ti Piace",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  fontSize: 24.sp,
                  color: Colors.black,
                ),
              ),
            ),
            UIHelper.verticalSpace(20.h),
            Image.asset(
              Assets.images.onboard16.path,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.contain,
            ),

            UIHelper.verticalSpace(20.h),

            Align(
              alignment: Alignment.center,
              child: Text(
                "Per supportare la qualità del servizio dopo la prova gratuita, chiediamo un piccolo contributo se ti piace l'app.",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          onPressed: () {
            // Save all onboarding data to GetStorage (pending keys for screen 17)
            appData.write(kKeyPendingOnboard1, widget.onboard1);
            appData.write(kKeyPendingOnboard2, widget.onboard2);
            appData.write(kKeyPendingOnboard4, widget.onboard4);
            appData.write(kKeyPendingOnboard5, widget.onboard5);
            appData.write(kKeyPendingOnboard7HeightValue, widget.onboard7HeightValue);
            appData.write(kKeyPendingOnboard7HeightUnit, widget.onboard7HeightUnit);
            appData.write(kKeyPendingOnboard8WeightValue, widget.onboard8WeightValue);
            appData.write(kKeyPendingOnboard8WeightUnit, widget.onboard8WeightUnit);
            appData.write(kKeyPendingOnboard9TargetWeightValue, widget.onboard9TargetWeightValue);
            appData.write(kKeyPendingOnboard9TargetWeightUnit, widget.onboard9TargetWeightUnit);
            appData.write(kKeyPendingSelectedDate, widget.selectedDate.toIso8601String());
            appData.write(kKeyPendingBmi, widget.bmi);
            appData.write(kKeyPendingOnboard12, widget.onboard12);
            appData.write(kKeyPendingOnboard13, widget.onboard13);
            appData.write(kKeyPendingOnboard15, widget.onboard15);

            // Also save to regular keys so PlanReadyScreen can display them
            appData.write(kKeyonboard7HeightValue, widget.onboard7HeightValue);
            appData.write(kKeyonboard7HeightUnit, widget.onboard7HeightUnit);
            appData.write(kKeyonboard8HeightValue, widget.onboard8WeightValue);
            appData.write(kKeyonboard8HeightUnit, widget.onboard8WeightUnit);
            appData.write(kKeyonboard9HeightValue, widget.onboard9TargetWeightValue);
            appData.write(kKeyonboard9HeightUnit, widget.onboard9TargetWeightUnit);

            // Navigate to signature screen
            NavigationService.navigateToReplacement(
              Routes.onboardingScreen17,
            );
          },
          child: Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Continua",
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
