import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/networks/dio/dio.dart';
import 'package:gritti_app/services/subscription_service.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../networks/api_acess.dart';

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

  void _resubscribe(BuildContext context) {
    final paymentSource = appData.read('payment_source');

    if (paymentSource == 'web2wave') {
      // Web2Wave: open manage subscription page
      final email = appData.read(kKeyEmail)?.toString() ?? '';
      final url = Uri.parse(
        'https://dolce-reset-ltd.web2wave.com/manage-subscription?email=${Uri.encodeComponent(email)}',
      );
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // IAP: show Superwall paywall
      Superwall.shared.register('resubscribe').then((_) {
        // Check if subscription became active
        subscriptionService.checkAndSaveSuperwallStatus().then((active) {
          if (active) {
            NavigationService.navigateToUntilReplacement(Routes.loadingScreen);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentSource = appData.read('payment_source');
    final isWeb2Wave = paymentSource == 'web2wave';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.credit_card_off_rounded,
                  size: 40.sp,
                  color: const Color(0xFFDC2626),
                ),
              ),

              SizedBox(height: 32.h),

              // Title
              Text(
                'Abbonamento Scaduto',
                textAlign: TextAlign.center,
                style: GoogleFonts.workSans(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),

              SizedBox(height: 16.h),

              // Description
              Text(
                isWeb2Wave
                    ? 'Il tuo abbonamento è scaduto o è stato annullato. Rinnova il tuo abbonamento per continuare ad accedere a tutti i contenuti.'
                    : 'Il tuo abbonamento è scaduto o è stato annullato. Riattiva il tuo abbonamento per continuare ad accedere a tutti i contenuti.',
                textAlign: TextAlign.center,
                style: GoogleFonts.workSans(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),

              // Resubscribe button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => _resubscribe(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D3E39),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isWeb2Wave ? 'Gestisci Abbonamento' : 'Riattiva Abbonamento',
                    style: GoogleFonts.workSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Logout button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: OutlinedButton(
                  onPressed: () => _logout(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    backgroundColor: const Color(0xFFFEE2E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Esci',
                        style: GoogleFonts.workSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
