import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/networks/api_acess.dart';
import 'package:gritti_app/services/preload_service.dart';
import 'package:intl/intl.dart';

import '../authentication/widgets/logo_widget.dart';

class CacheLoadingScreen extends StatefulWidget {
  const CacheLoadingScreen({super.key});

  @override
  State<CacheLoadingScreen> createState() => _CacheLoadingScreenState();
}

class _CacheLoadingScreenState extends State<CacheLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _startLoading();
  }

  void _updateProgress(double value) {
    if (!mounted) return;
    setState(() {
      _progress = value.clamp(0.0, 1.0);
    });
  }

  Future<void> _startLoading() async {
    try {
      // Step 1: Submit pending onboarding data if exists (0% → 10%)
      _updateProgress(0.02);
      await _submitPendingOnboarding();
      _updateProgress(0.10);

      // Step 2: Preload API data & images (10% → 98%)
      // The onProgress callback maps preloadFullCache's 0.0→1.0 to our 0.10→0.98
      await preloadService.preloadFullCache(
        onProgress: (double p) {
          _updateProgress(0.10 + p * 0.88);
        },
      );

      // Step 3: Mark cache as loaded
      appData.write(kKeyCacheLoaded, true);
      appData.write(kKeyIsOnboarding, false);
      _updateProgress(1.0);

      // Small delay so user sees 100%
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      log('[CacheLoading] Error: $e');
      // Even on error, proceed to app
      appData.write(kKeyCacheLoaded, true);
      appData.write(kKeyIsOnboarding, false);
    }

    _navigateToApp();
  }

  Future<void> _submitPendingOnboarding() async {
    // Check if there's pending onboarding data to submit
    final pendingSignature = appData.read(kKeyPendingSignature);
    final pendingOnboard1 = appData.read(kKeyPendingOnboard1);

    if (pendingOnboard1 == null) {
      log('[CacheLoading] No pending onboarding data');
      return;
    }

    log('[CacheLoading] Submitting pending onboarding data...');

    try {
      // Decode signature from base64
      Uint8List? signatureBytes;
      if (pendingSignature != null) {
        signatureBytes = base64Decode(pendingSignature);
      }

      final onboard1 = appData.read(kKeyPendingOnboard1) ?? '';
      final onboard2 = appData.read(kKeyPendingOnboard2) ?? '';
      final onboard4 = appData.read(kKeyPendingOnboard4) ?? '';
      final onboard5 = appData.read(kKeyPendingOnboard5) ?? '';
      final onboard7HeightValue = appData.read(kKeyPendingOnboard7HeightValue) ?? 0;
      final onboard7HeightUnit = appData.read(kKeyPendingOnboard7HeightUnit) ?? '';
      final onboard8WeightValue = (appData.read(kKeyPendingOnboard8WeightValue) ?? 0.0).toDouble();
      final onboard8WeightUnit = appData.read(kKeyPendingOnboard8WeightUnit) ?? '';
      final onboard9TargetWeightValue = (appData.read(kKeyPendingOnboard9TargetWeightValue) ?? 0.0).toDouble();
      final onboard9TargetWeightUnit = appData.read(kKeyPendingOnboard9TargetWeightUnit) ?? '';
      final dateStr = appData.read(kKeyPendingSelectedDate);
      final selectedDate = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
      final bmi = (appData.read(kKeyPendingBmi) ?? 0.0).toDouble();
      final onboard12 = appData.read(kKeyPendingOnboard12) ?? '';
      final onboard13 = appData.read(kKeyPendingOnboard13) ?? '';
      final onboard15 = appData.read(kKeyPendingOnboard15) ?? '';

      await onboardingRxObj.onboardingRx(
        userId: appData.read(kKeyID).toString(),
        age: DateFormat('yyyy-MM-dd').format(selectedDate),
        bmi: bmi.toString(),
        bodyPartFocus: onboard2,
        bodySatisfaction: onboard15,
        celebrationPlan: onboard13,
        currentBodyType: onboard4,
        currentWeight: onboard8WeightValue.toString(),
        dreamBody: onboard5,
        height: onboard7HeightValue.toString(),
        targetWeight: onboard9TargetWeightValue.toString(),
        tryingDuration: onboard12,
        urgentImprovement: onboard1,
        signature: signatureBytes ?? Uint8List(0),
        heightIn: onboard7HeightUnit,
        targetWeightIn: onboard9TargetWeightUnit,
        weightIn: onboard8WeightUnit,
      );

      // Clear pending data after successful submission
      _clearPendingOnboardingData();
      log('[CacheLoading] Onboarding data submitted successfully');
    } catch (e) {
      log('[CacheLoading] Failed to submit onboarding: $e');
    }
  }

  void _clearPendingOnboardingData() {
    appData.remove(kKeyPendingOnboard1);
    appData.remove(kKeyPendingOnboard2);
    appData.remove(kKeyPendingOnboard4);
    appData.remove(kKeyPendingOnboard5);
    appData.remove(kKeyPendingOnboard7HeightValue);
    appData.remove(kKeyPendingOnboard7HeightUnit);
    appData.remove(kKeyPendingOnboard8WeightValue);
    appData.remove(kKeyPendingOnboard8WeightUnit);
    appData.remove(kKeyPendingOnboard9TargetWeightValue);
    appData.remove(kKeyPendingOnboard9TargetWeightUnit);
    appData.remove(kKeyPendingSelectedDate);
    appData.remove(kKeyPendingBmi);
    appData.remove(kKeyPendingOnboard12);
    appData.remove(kKeyPendingOnboard13);
    appData.remove(kKeyPendingOnboard15);
    appData.remove(kKeyPendingSignature);
    appData.remove(kKeyFromPaywall);
  }

  void _navigateToApp() {
    if (!mounted) return;
    NavigationService.navigateToUntilReplacement(
      Routes.navigationScreen,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              LogoWidget(title: ""),
              SizedBox(height: 40.h),
              Text(
                "Preparazione del tuo programma...",
                textAlign: TextAlign.center,
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Stiamo caricando i tuoi esercizi e contenuti",
                textAlign: TextAlign.center,
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF52525B),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 40.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8.h,
                  backgroundColor: const Color(0xFFE4E4E7),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF767EFF),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "${(_progress * 100).toInt()}%",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF767EFF),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}
