import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/device_helper.dart';
import 'package:gritti_app/helpers/di.dart';

import '../../common_widget/custom_button.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../helpers/ui_helpers.dart';

class RewiringBenefitScreen extends StatefulWidget {
  const RewiringBenefitScreen({super.key});

  @override
  State<RewiringBenefitScreen> createState() => _RewiringBenefitScreenState();
}

class _RewiringBenefitScreenState extends State<RewiringBenefitScreen> {
  bool _isLoadingPaywall = false;
  Timer? _paywallTimeout;

  @override
  void dispose() {
    _paywallTimeout?.cancel();
    super.dispose();
  }

  void _navigateAfterPayment() {
    bool cacheLoaded = appData.read(kKeyCacheLoaded) ?? false;
    if (!cacheLoaded) {
      NavigationService.navigateToUntilReplacement(Routes.cacheLoadingScreen);
    } else {
      NavigationService.navigateToUntilReplacement(Routes.navigationScreen);
    }
  }

  void _stopLoading() {
    _paywallTimeout?.cancel();
    if (mounted) {
      setState(() => _isLoadingPaywall = false);
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
              color: _isLoadingPaywall
                  ? const Color(0xFFF566A9).withOpacity(0.6)
                  : null,
              onPressed: _isLoadingPaywall
                  ? () {}
                  : () async {
                      setState(() => _isLoadingPaywall = true);

                      // iPad: Superwall can't complete purchases in
                      // iPhone compatibility mode — use native StoreKit.
                      if (await isIPad()) {
                        log("iPad detected — opening native paywall");
                        _stopLoading();
                        NavigationService.navigateTo(
                          Routes.nativePaywallScreen,
                        );
                        return;
                      }

                      // Timeout: if paywall doesn't present within 15s, fallback to native
                      _paywallTimeout = Timer(const Duration(seconds: 15), () {
                        log("Paywall timeout — opening native fallback");
                        _stopLoading();
                        NavigationService.navigateTo(
                          Routes.nativePaywallScreen,
                        );
                      });

                      // Present Superwall paywall
                      final handler = PaywallPresentationHandler();

                      handler.onPresent((info) {
                        log("Paywall presented: ${info.identifier}");
                        // Paywall appeared — cancel timeout, stop local loading
                        _stopLoading();
                      });

                      handler.onDismiss((info, result) {
                        log("Paywall dismissed with result: $result");
                        _stopLoading();
                        // Navigate after purchase or restore
                        if (result is PurchasedPaywallResult ||
                            result is RestoredPaywallResult) {
                          appData.write(kKeyPaymentMethod, 1);
                          bool isLoggedIn =
                              appData.read(kKeyIsLoggedIn) ?? false;
                          if (isLoggedIn) {
                            _navigateAfterPayment();
                          } else {
                            appData.write(kKeyFromPaywall, true);
                            NavigationService.navigateToReplacement(
                              Routes.signUpScreen,
                            );
                          }
                        }
                      });

                      handler.onError((error) {
                        log("Paywall error: $error — opening native fallback");
                        _stopLoading();
                        NavigationService.navigateTo(
                          Routes.nativePaywallScreen,
                        );
                      });

                      handler.onSkip((reason) {
                        log("Paywall skipped: $reason");
                        _stopLoading();
                        appData.write(kKeyPaymentMethod, 1);
                        bool isLoggedIn =
                            appData.read(kKeyIsLoggedIn) ?? false;
                        if (isLoggedIn) {
                          _navigateAfterPayment();
                        } else {
                          appData.write(kKeyFromPaywall, true);
                          NavigationService.navigateToReplacement(
                            Routes.signUpScreen,
                          );
                        }
                      });

                      try {
                        await Superwall.shared.registerPlacement(
                          'campaign_trigger',
                          handler: handler,
                        );
                      } catch (e) {
                        log("Superwall registerPlacement error: $e — opening native fallback");
                        _stopLoading();
                        NavigationService.navigateTo(
                          Routes.nativePaywallScreen,
                        );
                      }
                    },
              child: _isLoadingPaywall
                  ? SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Avanti",
                          style:
                              TextFontStyle.headLine16cFFFFFFWorkSansW600,
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
