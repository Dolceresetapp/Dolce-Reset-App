import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/gen/assets.gen.dart';

import '../../common_widget/custom_button.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../helpers/ui_helpers.dart';

class PaymentFreeScreen extends StatefulWidget {
  const PaymentFreeScreen({super.key});

  @override
  State<PaymentFreeScreen> createState() => _PaymentFreeScreenState();
}

class _PaymentFreeScreenState extends State<PaymentFreeScreen> {
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
                  "We want you to try \n Dolce Reset for FREE",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF000000),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Stack(
                children: [
                  Image.asset(
                    Assets.images.mask.path,
                    width: 1.sw,
                    fit: BoxFit.fitWidth,
                  ),

                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Text(
                      "No payment Due now",
                      textAlign: TextAlign.center,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600
                          .copyWith(
                            color: const Color(0xFF000000),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),

                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: CustomButton(
                      onPressed: () {
                        NavigationService.navigateTo(Routes.freeTrialScreen);
                      },
                      child: Row(
                        spacing: 10.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Try for \$0.00",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                          ),

                          SvgPicture.asset(
                            Assets.icons.rightArrows,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.cover,
                          ),
                          UIHelper.verticalSpace(20.h),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Text(
                      "3 days free, then €69.99 per year (€4.75 /mo)",
                      textAlign: TextAlign.center,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600
                          .copyWith(
                            color: const Color(0xFF000000),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
