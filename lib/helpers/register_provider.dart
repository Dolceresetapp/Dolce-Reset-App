import 'package:provider/provider.dart';
import '../provider/login_provider.dart';
import '../provider/otp_provider.dart';
import '../provider/reset_password_provider.dart';
import '../provider/sign_up_provider.dart';

var providers = [
  //New
  ChangeNotifierProvider<LoginProvider>(create: ((context) => LoginProvider())),

  ChangeNotifierProvider<SignupProvider>(
    create: ((context) => SignupProvider()),
  ),

   ChangeNotifierProvider<OtpProvider>(
    create: ((context) => OtpProvider()),
  ),

    ChangeNotifierProvider<ResetPasswordProvider>(
    create: ((context) => ResetPasswordProvider()),
  ),
];
