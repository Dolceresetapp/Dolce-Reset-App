import 'package:flutter/material.dart';
import 'package:gritti_app/features/onboarding/presentation/one_time_onboarding/onboard_screen_1.dart';
import 'constants/app_constants.dart';
import 'features/get_started/get_started_screen.dart';
import 'helpers/di.dart';
import 'helpers/helper_methods.dart';
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

  loadInitialData() async {
    await setInitValue();
    bool data = appData.read(kKeyIsLoggedIn) ?? false;

    if (data) {
      String token = appData.read(kKeyAccessToken);
      DioSingleton.instance.update(token);
      // getCourseTypeRxObj.getCourseType();
      //  getRecomendedCourseRxObj.getCourse();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    } else {
      return appData.read(kKeyIsFirstTime)
          ? OnboardScreen1()
          : GetStartedScreen();
    }
  }
}
