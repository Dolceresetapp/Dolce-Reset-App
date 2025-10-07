import 'package:provider/provider.dart';
import '../provider/login_provider.dart';
import '../provider/sign_up_provider.dart';

var providers = [
  //New
  ChangeNotifierProvider<LoginProvider>(create: ((context) => LoginProvider())),

  ChangeNotifierProvider<SignupProvider>(
    create: ((context) => SignupProvider()),
  ),
];
