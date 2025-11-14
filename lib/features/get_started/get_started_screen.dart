import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.images.womensBg.path),
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ///
            Positioned(
              bottom: 0,
              child: Image.asset(
                Assets.images.rectangle.path,
                width: 1.sw,
                height: 0.5.sh,
                fit: BoxFit.cover,
              ),
            ),

            ///
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to the \n Woman Fit!",
                        textAlign: TextAlign.center,
                        style: TextFontStyle.headline30c27272AtyleWorkSansW700,
                      ),
                      UIHelper.verticalSpace(16.h),

                      Text(
                        "Intelligent fitness to enhance and grow \n your endurance, anytime anywhere.",
                        textAlign: TextAlign.center,
                        style: TextFontStyle.headline30c27272AtyleWorkSansW700
                            .copyWith(
                              color: Color(0xFF52525B),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                      ),

                      UIHelper.verticalSpace(48.h),

                      CustomButton(
                        color: const Color(0xFFF17389),
                        onPressed: () {
                          appData.write(kKeyIsFirst, false);
                          NavigationService.navigateToReplacement(
                            Routes.onboardingScreen1,
                          );
                        },
                        child: Row(
                          spacing: 10.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Get Started",
                              style:
                                  TextFontStyle.headLine16cFFFFFFWorkSansW600,
                            ),

                            SvgPicture.asset(
                              Assets.icons.arrowRight,
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),

                      UIHelper.verticalSpace(24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
