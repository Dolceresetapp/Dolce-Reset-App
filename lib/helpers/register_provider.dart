import 'package:gritti_app/provider/cache_video_provider.dart';
import 'package:gritti_app/provider/motivation_provider.dart';
import 'package:provider/provider.dart';

import '../provider/chef_provider.dart';
import '../provider/login_provider.dart';
import '../provider/otp_provider.dart';
import '../provider/reset_password_provider.dart';
import '../provider/sign_up_provider.dart';

var providers = [
  //New
  ChangeNotifierProvider<LoginProvider>(create: ((context) => LoginProvider())),

  ChangeNotifierProvider<ChefProvider>(create: ((context) => ChefProvider())),

  ChangeNotifierProvider<SignupProvider>(
    create: ((context) => SignupProvider()),
  ),

  ChangeNotifierProvider<OtpProvider>(create: ((context) => OtpProvider())),

  ChangeNotifierProvider<ResetPasswordProvider>(
    create: ((context) => ResetPasswordProvider()),
  ),

  ChangeNotifierProvider<MotivationProvider>(
    create: ((context) => MotivationProvider()),
  ),

   ChangeNotifierProvider<CacheVideoProvider>(
    create: ((context) => CacheVideoProvider()),
  ),
];
