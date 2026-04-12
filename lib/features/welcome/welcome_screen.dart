import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/services/preload_service.dart';

import '../../common_widget/custom_button.dart';
import '../../constants/app_constants.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/di.dart';
import '../../helpers/navigation_service.dart';
import '../../helpers/ui_helpers.dart';
import '../authentication/widgets/logo_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    preloadService.preloadOnLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const Spacer(flex: 2),
              LogoWidget(title: "Benvenuta in Dolce Reset"),
              UIHelper.verticalSpace(16.h),
              Text(
                "Il tuo percorso verso una vita pi\u00f9 sana e in forma inizia qui.",
                textAlign: TextAlign.center,
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF52525B),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(flex: 3),
              CustomButton(
                onPressed: () {
                  NavigationService.navigateTo(
                    Routes.onboardingScreen1,
                  );
                },
                child: Row(
                  spacing: 10.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Inizia",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
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
              Align(
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hai gi\u00e0 ',
                        style: TextFontStyle.headline30c27272AtyleWorkSansW700
                            .copyWith(
                              color: const Color(0xFF52525B),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigationService.navigateTo(
                              Routes.signInScreen,
                            );
                          },
                        text: 'un account?',
                        style: TextFontStyle.headline30c27272AtyleWorkSansW700
                            .copyWith(
                              decoration: TextDecoration.underline,
                              fontSize: 14.sp,
                              color: const Color(0xFF767EFF),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              UIHelper.verticalSpace(16.h),
              GestureDetector(
                onTap: () {
                  appData.write(kKeyIsGuest, true);
                  NavigationService.navigateToUntilReplacement(
                    Routes.navigationScreen,
                  );
                },
                child: Text(
                  'Esplora i contenuti',
                  style: TextFontStyle.headline30c27272AtyleWorkSansW700
                      .copyWith(
                        decoration: TextDecoration.underline,
                        fontSize: 14.sp,
                        color: const Color(0xFF71717A),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
