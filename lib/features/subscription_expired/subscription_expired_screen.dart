import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/networks/dio/dio.dart';
import 'package:gritti_app/services/subscription_service.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../../common_widget/custom_button.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/toast.dart';
import '../../networks/api_acess.dart';
import '../authentication/widgets/logo_widget.dart';

class SubscriptionExpiredScreen extends StatelessWidget {
  const SubscriptionExpiredScreen({super.key});

  void _logout(BuildContext context) {
    logoutRxObj.logoutRx().waitingForFuture().then((success) {
      appData.write(kKeyIsLoggedIn, false);
      appData.write(kKeyPaymentMethod, 0);
      appData.remove('payment_source');
      subscriptionService.onLogout();
      DioSingleton.instance.update('');
      NavigationService.navigateToUntilReplacement(Routes.welcomeScreen);
    });
  }

  void _resubscribe(BuildContext context) async {
    final handler = PaywallPresentationHandler();

    handler.onDismiss((info, result) {
      if (result is PurchasedPaywallResult || result is RestoredPaywallResult) {
        appData.write(kKeyPaymentMethod, 1);
        // Switch to IAP — no longer a Web2Wave user
        appData.remove('payment_source');
        NavigationService.navigateToUntilReplacement(Routes.loadingScreen);
      }
      // If dismissed without purchase, user stays on this screen
    });

    handler.onSkip((reason) {
      // User already has access (Superwall knows)
      appData.write(kKeyPaymentMethod, 1);
      appData.remove('payment_source');
      NavigationService.navigateToUntilReplacement(Routes.loadingScreen);
    });

    handler.onError((error) {
      log('[SubscriptionExpired] Paywall error: $error');
      ToastUtil.showErrorShortToast("Errore durante il pagamento");
    });

    await Superwall.shared.registerPlacement(
      'campaign_trigger',
      handler: handler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              LogoWidget(title: "Abbonamento Scaduto"),

              UIHelper.verticalSpace(24.h),

              // Description
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F5),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFF566A9).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 28.sp,
                      color: const Color(0xFFF566A9),
                    ),
                    UIHelper.verticalSpace(12.h),
                    Text(
                      "Il tuo abbonamento è scaduto o è stato annullato. Riattiva per continuare ad accedere a tutti i contenuti di Dolce Reset.",
                      textAlign: TextAlign.center,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFF52525B),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Resubscribe button (primary pink)
              CustomButton(
                onPressed: () => _resubscribe(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10.w,
                  children: [
                    Text(
                      "Riprendi il mio abbonamento",
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

              UIHelper.verticalSpace(16.h),

              // Logout button (outlined style)
              CustomButton(
                onPressed: () => _logout(context),
                color: Colors.white,
                borderSide: BorderSide(
                  color: const Color(0xFFE4E4E7),
                  width: 1.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10.w,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 20.sp,
                      color: const Color(0xFF52525B),
                    ),
                    Text(
                      "Esci",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: const Color(0xFF52525B),
                      ),
                    ),
                  ],
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
