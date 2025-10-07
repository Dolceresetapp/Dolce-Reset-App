import 'package:flutter/material.dart';

import 'constants/app_constants.dart';
import 'features/authentication/sign_up/sign_up_screen.dart';
import 'helpers/di.dart';
import 'helpers/helper_methods.dart';
import 'networks/dio/dio.dart';
import 'splash_screen.dart';

// import 'helpers/helper_methods.dart';
// import 'constants/app_constants.dart';
// import 'helpers/app_version_updater.dart';
// import 'helpers/di.dart';

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
      return const SignUpScreen();
    }
  }
}
