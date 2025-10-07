
import 'package:provider/provider.dart';
import '../provider/login_provider.dart';


var providers = [
  //New
    ChangeNotifierProvider<LoginProvider>(
    create: ((context) => LoginProvider()),
  ), 
  
];
