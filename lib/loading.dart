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
import 'features/dynamic_workout/data/rx_get/api.dart';
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

        // Step 1: Identify user with Superwall (needed for IAP users)
        await subscriptionService.identifyUser();

        // Step 2: Check subscription based on payment source
        final paymentSource = appData.read('payment_source');
        log('[Loading] payment_source: $paymentSource');

        if (paymentSource == 'web2wave') {
          // Web2Wave: check backend (which calls Web2Wave API)
          log('[Loading] Web2Wave user — checking backend...');
          appData.write(kKeyUsrInfo, 1); // Onboarding done on web
          await subscriptionService.syncSubscriptionStatus();
          log('[Loading] After sync: kKeyPaymentMethod = ${appData.read(kKeyPaymentMethod)}');
        } else {
          // IAP users: check Superwall (StoreKit / Google Play)
          log('[Loading] IAP user — checking Superwall...');
          bool superwallActive = await subscriptionService.checkAndSaveSuperwallStatus();
          log('[Loading] Superwall active: $superwallActive');

          if (superwallActive) {
            appData.write(kKeyPaymentMethod, 1);
            appData.write(kKeyUsrInfo, 1);
          }
          // If Superwall inactive AND no payment source → user hasn't paid
          // kKeyPaymentMethod stays at whatever was set during login
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

  /// Preload categories, themes, and other frequently used data
  void _preloadApiData() {
    // Fire and forget - don't block UI
    // Phase 1: Load main data
    Future.wait([
      categoryRxObj.categoryRx().catchError((_) => false),
      themeRxObj.themeRx().catchError((_) => false),
      myWorkoutRxObj.myWorkoutRx().catchError((_) => false),
    ]).then((_) {
      // Phase 2: After main data loaded, preload dynamic workouts for each
      _preloadDynamicWorkouts();
    });
  }

  /// Preload dynamic workouts for all categories and themes
  /// Uses API directly to warm the cache WITHOUT polluting the shared BehaviorSubject
  void _preloadDynamicWorkouts() {
    final api = DynamicWorkoutApi.instance;

    // Preload body part exercises (categories)
    categoryRxObj.categoryRxStream.first.then((categories) {
      if (categories.data != null) {
        for (final category in categories.data!) {
          if (category.id != null) {
            api.dynamicWorkoutApi(
              type: "body_part_exercise",
              id: category.id,
            ).ignore();
          }
        }
      }
    }).ignore();

    // Preload theme workouts
    themeRxObj.themeRxStream.first.then((themes) {
      if (themes.data != null) {
        for (final theme in themes.data!) {
          if (theme.id != null) {
            api.dynamicWorkoutApi(
              type: "theme_workout",
              id: theme.id,
            ).ignore();
          }
        }
      }
    }).ignore();

    // Preload training levels
    for (final level in ["beginner", "intermediate", "advanced"]) {
      api.dynamicWorkoutApi(
        type: "training_level",
        levelType: level,
      ).ignore();
    }
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
