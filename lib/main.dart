// ignore_for_file: deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gritti_app/loading.dart';
import 'package:provider/provider.dart';

import '/helpers/all_routes.dart';
import 'firebase_options.dart';
import 'gen/colors.gen.dart';
import 'helpers/di.dart';
import 'helpers/helper_methods.dart';
import 'helpers/navigation_service.dart';
import 'helpers/register_provider.dart';
import 'networks/dio/dio.dart';

//Future<void> backgroundHandler(RemoteMessage message) async {}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Performance: Run init tasks in parallel where possible
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    GetStorage.init(),
    _initStripe(),
  ]);

  diSetup();
  initiInternetChecker();
  DioSingleton.instance.create();

  // Init these once at startup, not in build
  rotation();
  setInitValue();

  // Optimize rendering
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

Future<void> _initStripe() async {
  Stripe.publishableKey =
      "pk_test_51ReqwVPDus5Inpom946CpZJ839v8LandcGNRmku71XxO9xxAtoTQu9FV1BAm9KOzYZayv9DhMfLS0J6KMqK73VLg0044KYKdBM";
  await Stripe.instance.applySettings();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: const UtillScreenMobile(),
    );
  }
}

class UtillScreenMobile extends StatelessWidget {
  const UtillScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 827),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          showPerformanceOverlay: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.cFFFFFF,
            useMaterial3: false,
            // Performance optimizations
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
          home: const Loading(),
        );
      },
    );
  }
}

// dolcereset#123  -> keystore password
