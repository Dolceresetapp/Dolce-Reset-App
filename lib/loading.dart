import 'package:flutter/material.dart';
import 'package:gritti_app/features/authentication/sign_up/sign_up_screen.dart';

import 'constants/app_constants.dart';
import 'helpers/di.dart';
import 'helpers/helper_methods.dart';
import 'navigation_screen.dart';
import 'networks/api_acess.dart';
import 'networks/dio/dio.dart';
import 'splash_screen.dart';

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
    bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;

    if (isLoggedIn) {
      String token = appData.read(kKeyAccessToken);
      DioSingleton.instance.update(token);

      // Preload all main API data in background (don't wait)
      _preloadApiData();
    }

    setState(() {
      _isLoading = false;
    });
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
  void _preloadDynamicWorkouts() {
    // Preload body part exercises (categories)
    categoryRxObj.categoryRxStream.first.then((categories) {
      if (categories.data != null) {
        for (final category in categories.data!) {
          if (category.id != null) {
            dynamicWorkoutRxObj.dynamicWorkoutRx(
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
            dynamicWorkoutRxObj.dynamicWorkoutRx(
              type: "theme_workout",
              id: theme.id,
            ).ignore();
          }
        }
      }
    }).ignore();

    // Preload training levels
    for (final level in ["beginner", "intermediate", "advanced"]) {
      dynamicWorkoutRxObj.dynamicWorkoutRx(
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
      return appData.read(kKeyIsLoggedIn)
          ? NavigationScreen()
          : SignUpScreen();
    }
  }
}
