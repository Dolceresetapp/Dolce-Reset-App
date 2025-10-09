import 'package:flutter/material.dart';
import 'package:flutter_ruler/flutter_ruler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import '../../../../common_widget/custom_button.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/navigation_service.dart';

class KgWidget extends StatelessWidget {
  final int kgValue;

  const KgWidget({super.key, required this.kgValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  kgValue.toString(),
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 96.sp,

                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(
                  height: 45.h,
                  child: Text(
                    'kg',
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF52525B),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
          ),

          UIHelper.verticalSpace(20.h),

          FlutterRuler(
            minValue: 1,
            maxValue: kgValue,
            rulerWidth: double.infinity,
            rulerHeight: 140.h,
            pointerDecoration: PointerDecoration(
              color: Color(0xFF777EFF),
              pointerWidth: 4.w,
              pointerHeight: 200.h,
            ),
            lineDecoration: LineDecoration(
              smallLineDecoration: SmallLineDecoration(
                color: Color(0xFFD4D4D8),
                lineHeight: 30.h,
                lineWidth: 3.w,
              ),
              mediumLineDecoration: MediumLineDecoration(
                color: Colors.grey,
                lineHeight: 60.h,
                lineWidth: 3.w,
              ),
              largeLineDecoration: LargeLineDecoration(color: Colors.black),
            ),
            numberTextStyle: TextFontStyle.headLine16cFFFFFFWorkSansW600
                .copyWith(
                  color: const Color(0xFF52525B),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomButton(
        onPressed: () {
          NavigationService.navigateToReplacement(Routes.onboardingScreen7);
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
              Assets.icons.vector1,
              width: 20.w,
              height: 20.h,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
