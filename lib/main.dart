// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gritti_app/loading.dart';
import 'package:provider/provider.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'dart:developer';

import 'constants/app_constants.dart';
import '/helpers/all_routes.dart';
import 'firebase_options.dart';
import 'gen/colors.gen.dart';
import 'services/subscription_service.dart';
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
  ]);

  // Configure Superwall - handles StoreKit (iOS) & Google Play (Android) natively
  Superwall.configure('pk_-kUayHzDoFfqEBP6qAHws');

  diSetup();

  // Configure audio to play even when iPhone is in silent mode
  AudioPlayer.global.setAudioContext(AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: {
        AVAudioSessionOptions.mixWithOthers,
      },
    ),
    android: AudioContextAndroid(
      isSpeakerphoneOn: false,
      stayAwake: true,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
      audioFocus: AndroidAudioFocus.gain,
    ),
  ));

  // Initialize subscription service with Superwall delegate
  // Must be after diSetup() to have DioSingleton available
  subscriptionService.initialize();
  // initiInternetChecker() removed — triggers iOS local network permission
  // dialog for no reason (listener body was empty/commented out)
  DioSingleton.instance.create();

  // Init these once at startup, not in build
  rotation();
  setInitValue();

  // Optimize rendering
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
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

class UtillScreenMobile extends StatefulWidget {
  const UtillScreenMobile({super.key});

  @override
  State<UtillScreenMobile> createState() => _UtillScreenMobileState();
}

class _UtillScreenMobileState extends State<UtillScreenMobile> {
  late final AppLinks _appLinks;
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initDeepLinkHandling();
  }

  Future<void> _initDeepLinkHandling() async {
    // Handle initial deep link (cold start)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (_) {}

    // Handle deep links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    log('[DeepLink] Received: $uri');

    // Check if this is a Web2Wave deep link (has user_id or email param)
    final userId = uri.queryParameters['user_id'];
    final email = uri.queryParameters['email'];

    if (userId != null || email != null) {
      log('[DeepLink] Web2Wave link detected - user_id: $userId, email: $email');

      // Only ignore deep link if user is fully set up (logged in + payment active)
      bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
      int paymentMethod = appData.read(kKeyPaymentMethod) ?? 0;
      if (isLoggedIn && paymentMethod == 1) {
        log('[DeepLink] User already logged in with active payment, ignoring Web2Wave link');
        return;
      }

      // Clear any stale state from a previous failed attempt
      if (isLoggedIn && paymentMethod != 1) {
        log('[DeepLink] Stale login state detected, clearing...');
        appData.write(kKeyIsLoggedIn, false);
      }

      // Store for use in sign-in screen
      if (email != null) {
        appData.write('web2wave_email', email);
      }
      if (userId != null) {
        appData.write('web2wave_user_id', userId);
      }

      // Also pass to Superwall in case the link contains subscription info
      Superwall.shared.handleDeepLink(uri);

      // Navigate to sign-in with email pre-filled (Web2Wave redeem mode)
      NavigationService.navigateToReplacement(Routes.signInScreen);
      return;
    }

    // Not a Web2Wave link — pass to Superwall
    Superwall.shared.handleDeepLink(uri);
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

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
