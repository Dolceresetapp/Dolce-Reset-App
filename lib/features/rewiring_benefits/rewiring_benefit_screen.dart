import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/di.dart';

import '../../common_widget/custom_button.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../helpers/toast.dart';
import '../../helpers/ui_helpers.dart';

class RewiringBenefitScreen extends StatefulWidget {
  const RewiringBenefitScreen({super.key});

  @override
  State<RewiringBenefitScreen> createState() => _RewiringBenefitScreenState();
}

class _RewiringBenefitScreenState extends State<RewiringBenefitScreen> {
  void _navigateAfterPayment() {
    bool cacheLoaded = appData.read(kKeyCacheLoaded) ?? false;
    if (!cacheLoaded) {
      NavigationService.navigateToUntilReplacement(Routes.cacheLoadingScreen);
    } else {
      NavigationService.navigateToUntilReplacement(Routes.navigationScreen);
    }
  }

  List<String> imageList = [
    Assets.images.card.path,
    Assets.images.card1.path,
    Assets.images.card2.path,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "I Tuoi Benefici",
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF000000),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          spacing: 20.h,
          children: [
            ListView.builder(
              itemCount: imageList.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),

              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Image.asset(imageList[index]),
                );
              },
            ),

            CustomButton(
              onPressed: () async {
                // Present Superwall paywall
                final handler = PaywallPresentationHandler();

                handler.onPresent((info) {
                  log("Paywall presented: ${info.identifier}");
                });

                handler.onDismiss((info, result) {
                  log("Paywall dismissed with result: $result");
                  // Navigate after purchase or restore
                  if (result is PurchasedPaywallResult ||
                      result is RestoredPaywallResult) {
                    appData.write(kKeyPaymentMethod, 1);
                    bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
                    if (isLoggedIn) {
                      // User is logged in → check cache then go to app
                      _navigateAfterPayment();
                    } else {
                      // User is NOT logged in → go to signup with paywall flag
                      appData.write(kKeyFromPaywall, true);
                      NavigationService.navigateToReplacement(
                        Routes.signUpScreen,
                      );
                    }
                  }
                  // If declined or closed, user stays on current screen
                });

                handler.onError((error) {
                  log("Paywall error: $error");
                  ToastUtil.showErrorShortToast("Errore durante il pagamento");
                });

                handler.onSkip((reason) {
                  log("Paywall skipped: $reason");
                  // User already has access
                  appData.write(kKeyPaymentMethod, 1);
                  bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
                  if (isLoggedIn) {
                    _navigateAfterPayment();
                  } else {
                    appData.write(kKeyFromPaywall, true);
                    NavigationService.navigateToReplacement(
                      Routes.signUpScreen,
                    );
                  }
                });

                await Superwall.shared.registerPlacement(
                  'campaign_trigger',
                  handler: handler,
                );
              },
              child: Row(
                spacing: 10.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Avanti",
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

            UIHelper.verticalSpaceLarge,
          ],
        ),
      ),
    );
  }
}
