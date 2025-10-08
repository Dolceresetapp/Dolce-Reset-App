import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../features/authentication/forget_otp/forget_otp_screen.dart';
import '../features/authentication/reset_password/reset_password_screen.dart';
import '../features/authentication/sign_up/sign_up_screen.dart';
import '../features/authentication/signin/sign_in_screen.dart';
import '../features/authentication/signup_otp/signup_otp_screen.dart';
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
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {

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
