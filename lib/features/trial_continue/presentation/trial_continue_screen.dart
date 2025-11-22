import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/features/trial_continue/widgets/timeline_stepper_widget.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

import '../../../common_widget/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';

class TrialContinueScreen extends StatefulWidget {
  const TrialContinueScreen({super.key});

  @override
  State<TrialContinueScreen> createState() => _TrialContinueScreenState();
}

class _TrialContinueScreenState extends State<TrialContinueScreen> {
  bool isChecked = false;

  void toogleChange(bool value) {
    setState(() {
      isChecked = value;
    });
  }

  bool isSelected = false;

  int? selectedIndex; // 0 = Monthly, 1 = Yearly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              UIHelper.verticalSpace(20.h),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Start your 3-day FREE trial to continue",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF000000),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              UIHelper.verticalSpace(50.h),

              TimelineStepperWidget(),

              UIHelper.verticalSpace(50.h),

              Row(
                spacing: 20.w,

                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.w,
                            color:
                                selectedIndex == 0
                                    ? Color(0xFFE2448B)
                                    : Colors.transparent,
                          ),
                          color: Color(0xFFFFDFF0),
                          borderRadius: BorderRadius.circular(14.r),
                        ),

                        child: Column(
                          spacing: 10.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Monthly",
                              style: TextFontStyle
                                  .headLine16cFFFFFFWorkSansThinW600
                                  .copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                            ),

                            Text(
                              "€37.00 /mo",
                              style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                  .copyWith(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Yearly Package
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },

                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.w,
                            color:
                                selectedIndex == 1
                                    ? Color(0xFFE2448B)
                                    : Colors.transparent,
                          ),
                          color: Color(0xFFFFDFF0),
                          borderRadius: BorderRadius.circular(14.r),
                        ),

                        child: Column(
                          spacing: 10.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Yearly",
                              style: TextFontStyle
                                  .headLine16cFFFFFFWorkSansThinW600
                                  .copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                            ),

                            Text(
                              "€4.75 /mo",
                              style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                  .copyWith(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpace(20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10.w,

                children: [
                  MSHCheckbox(
                    style: MSHCheckboxStyle.fillScaleCheck,
                    size: 20.sp,
                    value: isChecked,
                    onChanged: (value) => toogleChange(value),
                    colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                      checkedColor: Color(0xFFF566A9),
                      uncheckedColor: Color(0xFFD4D4D8),
                    ),
                  ),

                  Text(
                    "No payment Due now",
                    textAlign: TextAlign.center,
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF000000),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpace(20.h),

              CustomButton(
                onPressed: () {
                  // NavigationService.navigateTo(Routes.freeTrialScreen);
                },
                child: Row(
                  spacing: 10.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue for FREE",
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

              UIHelper.verticalSpace(10.h),

              Text(
                "3 days free, then €69.99 per year (€4.75 /mo)",
                textAlign: TextAlign.center,
                style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600.copyWith(
                  color: const Color(0xFF000000),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
