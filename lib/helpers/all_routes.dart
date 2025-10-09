import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../features/authentication/forget_otp/forget_otp_screen.dart';
import '../features/authentication/forget_password/forget_passwod._screen.dart';
import '../features/authentication/reset_password/reset_password_screen.dart';
import '../features/authentication/sign_up/sign_up_screen.dart';
import '../features/authentication/signin/sign_in_screen.dart';
import '../features/authentication/signup_otp/signup_otp_screen.dart';
import '../features/onboarding/presentation/onboarding_screen_1.dart';
import '../features/onboarding/presentation/onboarding_screen_10.dart';
import '../features/onboarding/presentation/onboarding_screen_11.dart';
import '../features/onboarding/presentation/onboarding_screen_12.dart';
import '../features/onboarding/presentation/onboarding_screen_13.dart';
import '../features/onboarding/presentation/onboarding_screen_2.dart';
import '../features/onboarding/presentation/onboarding_screen_3.dart';
import '../features/onboarding/presentation/onboarding_screen_4.dart';
import '../features/onboarding/presentation/onboarding_screen_5.dart';
import '../features/onboarding/presentation/onboarding_screen_6.dart';
import '../features/onboarding/presentation/onboarding_screen_7.dart';
import '../features/onboarding/presentation/onboarding_screen_8.dart';
import '../features/onboarding/presentation/onboarding_screen_9.dart';
import '../loading.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  static const String loadingScreen = '/Loading';

  static const String signUpScreen = '/signUpScreen';

  static const String signInScreen = '/signInScreen';

  static const String resetPasswordScreen = '/resetPasswordScreen';

  static const String signupOtpScreen = '/signupOtpScreen';

  static const String forgetOtpScreen = '/forgetOtpScreen';

  static const String onboardingScreen2 = '/onboardingScreen2';

  static const String onboardingScreen3 = '/onboardingScreen3';
  static const String onboardingScreen4 = '/onboardingScreen4';

  static const String onboardingScreen5 = '/onboardingScreen5';

  static const String onboardingScreen6 = '/onboardingScreen6';

  static const String onboardingScreen7 = '/onboardingScreen7';

  static const String onboardingScreen1 = '/onboardingScreen1';

  static const String forgetPasswordScreen = '/forgetPasswordScreen';

  static const String onboardingScreen8 = '/onboardingScreen8';

  static const String onboardingScreen9 = '/onboardingScreen9';

  static const String onboardingScreen12 = '/onboardingScreen12';
  static const String onboardingScreen11 = '/onboardingScreen11';

    static const String onboardingScreen10 = '/onboardingScreen10';

     static const String onboardingScreen13 = '/onboardingScreen13';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {

       case Routes.onboardingScreen13:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen13(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen13(),
            );


      case Routes.onboardingScreen11:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen11(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen11(),
            );

              case Routes.onboardingScreen10:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen10(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen10(),
            );


      case Routes.onboardingScreen12:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen12(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen12(),
            );

      case Routes.forgetPasswordScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const ForgetPasswordScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const ForgetPasswordScreen(),
            );

      case Routes.onboardingScreen1:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen1(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen1(),
            );

      case Routes.onboardingScreen9:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen9(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen9(),
            );

      case Routes.onboardingScreen8:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen8(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen8(),
            );

      case Routes.onboardingScreen7:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen7(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen7(),
            );

      case Routes.onboardingScreen6:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen6(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen6(),
            );

      case Routes.onboardingScreen5:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen5(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen5(),
            );

      case Routes.onboardingScreen4:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen4(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen4(),
            );

      case Routes.onboardingScreen3:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen3(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen3(),
            );

      case Routes.onboardingScreen2:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen2(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen2(),
            );

      case Routes.forgetOtpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const ForgetOtpScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => const ForgetOtpScreen());

      case Routes.signupOtpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const SignupOtpScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => const SignupOtpScreen());

      case Routes.resetPasswordScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const ResetPasswordScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const ResetPasswordScreen(),
            );

      case Routes.signInScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const SignInScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => const SignInScreen());

      case Routes.loadingScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const Loading(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const Loading());

      case Routes.signUpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const SignUpScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => const SignUpScreen());

      default:
        return null;
    }
  }
}

//  weenAnimationBuilder(
//   child: Widget,
//   tween: Tween<double>(begin: 0, end: 1),
//   duration: Duration(milliseconds: 1000),
//   curve: Curves.bounceIn,
//   builder: (BuildContext context, double _val, Widget child) {
//     return Opacity(
//       opacity: _val,
//       child: Padding(
//         padding: EdgeInsets.only(top: _val * 50),
//         child: child
//       ),
//     );
//   },
// );

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
    : super(
        settings: settings,
        reverseTransitionDuration: const Duration(milliseconds: 1),
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return widget;
        },
        transitionDuration: const Duration(milliseconds: 1),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
            child: child,
          );
        },
      );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: widget,
    );
  }
}
