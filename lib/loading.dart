import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gritti_app/features/cache_loading/cache_loading_screen.dart';
import 'package:gritti_app/features/onboarding/presentation/onboarding_screen_1.dart';
import 'package:gritti_app/features/rewiring_benefits/rewiring_benefit_screen.dart';
import 'package:gritti_app/features/subscription_expired/subscription_expired_screen.dart';
import 'package:gritti_app/features/welcome/welcome_screen.dart';

import 'constants/app_constants.dart';
import 'helpers/all_routes.dart';
import 'helpers/di.dart';
import 'helpers/navigation_service.dart';
import 'helpers/helper_methods.dart';
import 'navigation_screen.dart';
import 'networks/api_acess.dart';
import 'networks/dio/dio.dart';
import 'splash_screen.dart';
import 'services/preload_service.dart';
import 'services/subscription_service.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;

  @override
  void initState() {
    loadInitialData();
    super.initState();
  }

  Future<void> loadInitialData() async {
    await setInitValue();

    // Always preload public data (doesn't require login)
    preloadService.preloadOnLoginScreen();

    bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;

    if (isLoggedIn) {
      String? token = appData.read(kKeyAccessToken);
      if (token != null && token.isNotEmpty) {
        DioSingleton.instance.update(token);
        initAvatarNotifier();

        // Step 1: Identify user with Superwall (needed for IAP users)
        await subscriptionService.identifyUser();

        // Step 2: Always check Superwall first (IAP has priority)
        // This handles the case where a Web2Wave user resubscribed via IAP
        log('[Loading] Checking Superwall (IAP)...');
        bool superwallActive = await subscriptionService.checkAndSaveSuperwallStatus();
        log('[Loading] Superwall active: $superwallActive');

        if (superwallActive) {
          // User has active IAP subscription — this takes priority
          appData.write(kKeyPaymentMethod, 1);
          appData.write(kKeyUsrInfo, 1);
          // If user was previously Web2Wave, switch them to IAP
          final paymentSource = appData.read('payment_source');
          if (paymentSource == 'web2wave') {
            appData.remove('payment_source');
            log('[Loading] Switched from Web2Wave to IAP');
          }
        } else {
          // Superwall says inactive — check Web2Wave if applicable
          final paymentSource = appData.read('payment_source');
          log('[Loading] payment_source: $paymentSource');

          if (paymentSource == 'web2wave') {
            log('[Loading] Web2Wave user — checking backend...');
            appData.write(kKeyUsrInfo, 1); // Onboarding done on web
            await subscriptionService.syncSubscriptionStatus();
            log('[Loading] After sync: kKeyPaymentMethod = ${appData.read(kKeyPaymentMethod)}');
          }
          // If no payment source and Superwall inactive → user hasn't paid
        }

        // Only preload API data if user has completed onboarding and payment
        int userInfo = appData.read(kKeyUsrInfo) ?? 0;
        int paymentMethod = appData.read(kKeyPaymentMethod) ?? 0;
        if (userInfo == 1 && paymentMethod == 1) {
          // Preload all main API data in background (don't wait)
          _preloadApiData();
        }
      } else {
        // Token is missing, reset login state
        appData.write(kKeyIsLoggedIn, false);
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Preload categories, themes, and other frequently used data — gently
  void _preloadApiData() async {
    // Sequential loading with delays to avoid lag
    await categoryRxObj.categoryRx().catchError((_) => false);
    await Future.delayed(const Duration(milliseconds: 300));
    await themeRxObj.themeRx().catchError((_) => false);
    await Future.delayed(const Duration(milliseconds: 300));
    await myWorkoutRxObj.myWorkoutRx().catchError((_) => false);

    // Dynamic workouts load later in NavigationScreen via preloadService
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    } else {
      bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;

      if (!isLoggedIn) {
        // Check if arriving from Web2Wave deep link
        final web2waveEmail = appData.read('web2wave_email');
        if (web2waveEmail != null && web2waveEmail.toString().isNotEmpty) {
          log('[Loading] Web2Wave deep link detected -> SignInScreen');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.navigateToReplacement(Routes.signInScreen);
          });
          return const SplashScreen();
        }
        log('[Loading] Not logged in -> WelcomeScreen');
        return const WelcomeScreen();
      }

      // Check if user has completed onboarding and payment
      int userInfo = appData.read(kKeyUsrInfo) ?? 0;
      int paymentMethod = appData.read(kKeyPaymentMethod) ?? 0;

      log('[Loading] isLoggedIn: $isLoggedIn, userInfo: $userInfo, paymentMethod: $paymentMethod');

      // User is logged in but hasn't completed onboarding
      if (userInfo == 0) {
        log('[Loading] userInfo == 0 -> OnboardingScreen1');
        return OnboardingScreen1();
      }

      // User has completed onboarding but subscription is inactive
      if (paymentMethod == 0) {
        // Check if user previously had a subscription (expired/cancelled)
        final paymentSource = appData.read('payment_source');
        if (paymentSource != null) {
          log('[Loading] paymentMethod == 0, had payment_source=$paymentSource -> SubscriptionExpiredScreen');
          return const SubscriptionExpiredScreen();
        }
        // New user who hasn't paid yet
        log('[Loading] paymentMethod == 0, no payment_source -> RewiringBenefitScreen');
        return const RewiringBenefitScreen();
      }

      // Check if cache has been loaded
      bool cacheLoaded = appData.read(kKeyCacheLoaded) ?? false;
      if (!cacheLoaded) {
        log('[Loading] Cache not loaded -> CacheLoadingScreen');
        return const CacheLoadingScreen();
      }

      // User has completed everything, show main app
      log('[Loading] All complete -> NavigationScreen');
      return NavigationScreen();
    }
  }
}
