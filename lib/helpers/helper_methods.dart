// ignore_for_file: use_build_context_synchronously, unused_local_variable, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '/helpers/di.dart';
import '../constants/app_constants.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import 'ui_helpers.dart';

//final appData = locator.get<GetStorage>();
//final plcaeMarkAddress = locator.get<PlcaeMarkAddress>();
//declared for cart scrren calling bottom shit with this from reorder rx
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<PopupMenuButtonState<String>> popUpGlobalkey =
    GlobalKey<PopupMenuButtonState<String>>();

enum StatusType { order, delivery }

Color statuscolor(StatusType status, String statusCode) {
  late Color stcolor;
  if (StatusType.order == status) {
    switch (statusCode) {
      case OrderStatusNo.kPENDING:
        stcolor = OrderStatusColor.kPENDING;
        break;
      case OrderStatusNo.kACCEPTED:
        stcolor = OrderStatusColor.kACCEPTED;
        break;
      case OrderStatusNo.kFOODPROCESSING:
        stcolor = OrderStatusColor.kFOODPROCESSING;
        break;
      case OrderStatusNo.kFOODREADY:
        stcolor = OrderStatusColor.kFOODREADY;
        break;
      case OrderStatusNo.kFOODPICKED:
        stcolor = OrderStatusColor.kFOODPICKED;
        break;
      case OrderStatusNo.kFOODDELIVERED:
        stcolor = OrderStatusColor.kFOODDELIVERED;
        break;
      case OrderStatusNo.kCANCELLED:
        stcolor = OrderStatusColor.kCANCELLED;
        break;
      case OrderStatusNo.kREJECTEDBYSHOP:
        stcolor = OrderStatusColor.kREJECTEDBYSHOP;
        break;
      case OrderStatusNo.kFAILED:
        stcolor = OrderStatusColor.kFAILED;
        break;
    }
  }
  if (StatusType.delivery == status) {
    switch (statusCode) {
      case DeliveryStatusNo.kPENDIG:
        stcolor = DeliveryStatusColor.kPENDING;
        break;
      case DeliveryStatusNo.kONTRANSIT:
        stcolor = DeliveryStatusColor.kONTRANSIT;
        break;
      case DeliveryStatusNo.kARRIVEDATSHOP:
        stcolor = DeliveryStatusColor.kARRIVEDATSHOP;
        break;
      case DeliveryStatusNo.kDELIVERYMANCONFIRMED:
        stcolor = DeliveryStatusColor.kDELIVERYMANCONFIRMED;
        break;
      case DeliveryStatusNo.kDELIVERYSTARTED:
        stcolor = DeliveryStatusColor.kDELIVERYSTARTED;
        break;
      case DeliveryStatusNo.kDELIVERED:
        stcolor = DeliveryStatusColor.kDELIVERED;
        break;
    }
  }

  return stcolor;
}

String language(String languageKey) {
  late String language;

  switch (languageKey) {
    case kKeyEnglish:
      language = "English";
      break;
    case kKeyFrench:
      language = "French";
      break;
    case kKeyGerman:
      language = "Dutch";
      break;
    case kKeyRussian:
      language = "Russian";
      break;
    case kKeyPortuguese:
      language = "Portuguese";
      break;
    case kKeySpanish:
      language = "Spanish";
      break;
    default:
      language = "Portuguese";
  }
  return language;
}

Future<String?> networkImageToBase64(String imageUrl) async {
  http.Response response = await http.get(Uri.parse(imageUrl));
  final bytes = response.bodyBytes;

  // ignore: unnecessary_null_comparison
  return (bytes != null ? base64Encode(bytes) : null);
}

Future<void> setInitValue() async {
  // Map<String,dynamic> arabicDefault = {};
  await appData.writeIfNull(kKeyIsLoggedIn, false);


    await appData.writeIfNull(kKeyIsFirstTime, true);
  /*  appData.writeIfNull(kKeyLanguage, kKeyEnglish);
appData.writeIfNull(kKeyIsFirst, true);
appData.writeIfNull(kKeyIsLoggedIn, false);
//codemen
  await appData.writeIfNull(kKeySelectedLat, 22.818285677915657);
  await appData.writeIfNull(kKeySelectedLng, 89.5535583794117);

  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    appData.writeIfNull(
        kKeyDeviceID, iosDeviceInfo.identifierForVendor); // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo =
        await deviceInfo.androidInfo; // unique ID on Android
    appData.writeIfNull(kKeyDeviceID, androidDeviceInfo.id);
  } */
  await Future.delayed(const Duration(seconds: 2));
}

/* setLocationLatLong(LatLng latLng, {bool? selectedLocation = false}) async {
  await appData.write(kKeySelectedLat, latLng.latitude);
  await appData.write(kKeySelectedLng, latLng.longitude);
  await appData.write(kKeySelectedLocation, selectedLocation);
} */

/* Future<void> getAddressFromPosition(LatLng latLng, BuildContext context) async {
  List<Placemark> addresses =
      await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

  var address = addresses.first;

  Provider.of<PlcaeMarkAddress>(context, listen: false).changePlcaeMarkAddress(
    addres: address.street.toString(),
    cty: address.locality.toString(),
    st: address.administrativeArea.toString(),
    coun: address.country.toString(),
    post: address.postalCode.toString(),
    lati: latLng.latitude.toString(),
    longi: latLng.longitude.toString(),
  );
} */

Future<void> initiInternetChecker() async {
  InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1),
    checkInterval: const Duration(seconds: 2),
  ).onStatusChange.listen((status) {
    /*   switch (status) {
      case InternetConnectionStatus.connected:
        //ToastUtil.showShortToast('Data connection is available.'.tr);
        break;
      case InternetConnectionStatus.disconnected:
       // ToastUtil.showNoInternetToast();
        break;
    } */
  });
}

Completer<T> wrapInCompleter<T>(Future<T> future) {
  final completer = Completer<T>();
  future.then(completer.complete).catchError(completer.completeError);
  return completer;
}

Future<void> getInvisible() async {
  Future.delayed(const Duration(milliseconds: 500), () {});
}

/* GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [],
); */

/* void loginWithSocialMedia(String driver) async {
  String userId, name, email;

  try {
    if (driver == kGoogle) {
      //    googleSignIn.signOut();
      final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

      if (googleAccount != null) {
        userId = googleAccount.id;
        name = googleAccount.displayName!;
        email = googleAccount.email;
      }
    } else if (driver == kFacebook) {
      // FacebookLoginResult loginResult = await facebookLogin.logIn(['email']);
      // switch (loginResult.status) {
      //   case FacebookLoginStatus.cancelledByUser:
      //     return;

      //   case FacebookLoginStatus.error:
      //     throw Exception(loginResult.errorMessage);
      //     break;

      //   case FacebookLoginStatus.loggedIn:
      //     final token = loginResult.accessToken.token;
      //     final graphResponse = await http.get(
      //       Uri.parse(
      //           'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'),
      //     );
      //     final profile = json.decode(graphResponse.body);

      //     if (profile != null) {
      //       userId = profile['id'];
      //       name = profile['name'];
      //       email = profile['email'];
      //     }
      //     break;

      //   default:
      //     break;
      // }
    } else if (driver == kApple) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print(credential);

      if (credential.userIdentifier != null) {
        // await postSocailLoginRXObj.postSocailLogin(
        //     socialAuthId: credential.userIdentifier!,
        //     email: credential.email,
        //     firstName: credential.givenName,
        //     lastName: credential.familyName,
        //     registerType: "4");
      }
    }
  } catch (e) {
    ToastUtil.showLongToast(e.toString());
  }
} */

Future<File> getLocalFile(String filename) async {
  File f = File(filename);
  return f;
}

void showMaterialDialog(BuildContext context) {
  showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
          ),
          title: Column(
            children: [
              Text(
                "Exit",
                textAlign: TextAlign.center,
                style: TextFontStyle.text16c2F1E19StyleRobotoW600,
              ),
              UIHelper.verticalSpace(16.h),
              SizedBox(
                width: 250.w,
                child: DottedLine(
                  // lineThickness: 2.h,
                  dashColor: AppColors.c6C564C,
                  dashLength: 10.w,
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Text(
                "Do you want to exit this app?",
                textAlign: TextAlign.center,
                style: TextFontStyle.text16c6C564CStyleRobotoW400,
              ),
            ],
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          width: double.infinity,
                          height: 40.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.cB18E5E),
                          ),
                          // alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No",
                                style: TextFontStyle
                                    .text16c2F1E19StyleRobotoW600
                                    .copyWith(color: AppColors.c2F1E19),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // UIHelper.horizontalSpace(10.w),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else if (Platform.isIOS) {
                            exit(0);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          height: 40.sp,
                          decoration: ShapeDecoration(
                            gradient: const RadialGradient(
                              center: Alignment(0.00, -1.7),
                              radius: 2,
                              colors: [Color(0xFFEBE6E0), Color(0xFFCBC1B4)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          // alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Yes",
                                style: TextFontStyle
                                    .text16c2F1E19StyleRobotoW600
                                    .copyWith(color: AppColors.c2F1E19),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(10.h),
              ],
            ),
          ],
        ),
  );
}

void rotation() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

String formatDate(String inputDate) {
  // Parse the input date string into a DateTime object
  DateTime dateTime = DateTime.parse(inputDate);

  // Format the DateTime object into the desired output format
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

  return formattedDate;
}

// List<Map<int, List<Ayah>>> extractJuzData(QuranReponseModel quranResponse) {
//   // This map will group ayahs by their Juz number
//   Map<int, List<Ayah>> juzMap = {};

//   // Iterate over all surahs and their ayahs
//   for (var surah in quranResponse.data!.surahs!) {
//     for (var ayah in surah.ayahs!) {
//       // If the Juz number doesn't exist in the map, create a new entry
//       if (!juzMap.containsKey(ayah.juz)) {
//         juzMap[ayah.juz!] = [];
//       }
//       // Add the ayah to the correct Juz group
//       juzMap[ayah.juz!]!.add(ayah);
//     }
//   }

//   // Convert the map to a list of Juz entries for easy access
//   List<Map<int, List<Ayah>>> juzList = [];
//   juzMap.forEach((juzNumber, ayahs) {
//     juzList.add({juzNumber: ayahs});
//   });

//   return juzList;
// }
void showPickImageBottomSheet(
  BuildContext context,
  ValueNotifier<XFile?> imageFileNotifier, {
  bool showCameraOption = true,
}) {
  final textTheme = Theme.of(
    context,
  ).textTheme.apply(displayColor: Theme.of(context).colorScheme.onSurface);

  showCupertinoModalPopup(
    context: context,
    builder:
        (BuildContext context) => CupertinoActionSheet(
          title: TextStyleExample(
            name: 'Choose Image',
            style: textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.1,
            ),
          ),
          message: TextStyleExample(
            name: "Choose an image from your camera or existing gallery.",
            style: textTheme.bodyMedium!.copyWith(letterSpacing: 0.1),
          ),
          actions: <Widget>[
            // List of actions
            showCameraOption
                ? CupertinoActionSheetAction(
                  child: TextStyleExample(
                    name: 'Camera',
                    style: textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  onPressed: () {
                    selectImageFromCamera(context, imageFileNotifier);
                  },
                )
                : const SizedBox.shrink(),
            CupertinoActionSheetAction(
              child: TextStyleExample(
                name: 'Gallery',
                style: textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed: () {
                selectImageFromGallery(context, imageFileNotifier);
              },
            ),
          ],
          // A cancel button at the bottom of the modal popup
          cancelButton: CupertinoActionSheetAction(
            child: TextStyleExample(
              name: 'Close',
              style: textTheme.titleLarge!.copyWith(
                color: Colors.grey,
                letterSpacing: 0.1,
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Close the modal popup
            },
          ),
        ),
  );
}

Future<void> selectImageFromCamera(
  BuildContext context,
  ValueNotifier<XFile?> imageFileNotifier,
) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    imageFileNotifier.value = pickedFile;
  }
  // Collapse the modal popup menu for hiding bottom sheet
  if (context.mounted) {
    Navigator.pop(context);
  }
}

Future<void> selectImageFromGallery(
  BuildContext context,
  ValueNotifier<XFile?> imageFileNotifier,
) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    imageFileNotifier.value = pickedFile;
    // Collapse the modal popup menu for hiding bottom sheet
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}

class TextStyleExample extends StatelessWidget {
  const TextStyleExample({super.key, required this.name, required this.style});

  final String name;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.sp),
      child: Text(name, style: style.copyWith(letterSpacing: 1.0)),
    );
  }
}

String calculateDateDifference(String inputDate) {
  // Parse the input date string
  List<String> dateParts = inputDate.split('/');
  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);

  // Create a DateTime object from the input date
  DateTime startDate = DateTime(year, month, day);

  // Get the current date
  DateTime currentDate = DateTime.now();

  // Calculate the difference in years and months
  int yearsDifference = currentDate.year - startDate.year;
  int monthsDifference = currentDate.month - startDate.month;

  // Adjust if the month of the start date is after the current date
  if (monthsDifference < 0) {
    yearsDifference -= 1;
    monthsDifference += 12;
  }

  // Return a formatted string
  if (yearsDifference == 0 && monthsDifference == 0) {
    return '0 Month';
  } else if (yearsDifference == 0) {
    return '$monthsDifference month${monthsDifference > 1 ? 's' : ''}';
  } else if (monthsDifference == 0) {
    return '$yearsDifference year${yearsDifference > 1 ? 's' : ''}';
  } else {
    return '$yearsDifference year${yearsDifference > 1 ? 's' : ''} and $monthsDifference month${monthsDifference > 1 ? 's' : ''}';
  }
}

String getGreetingMessage() {
  final currentHour = DateTime.now().hour;

  if (currentHour < 12) {
    return 'Good Morning';
  } else if (currentHour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}

void showLogoutDialog(BuildContext context) {
  showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
          ),
          title: Column(
            children: [
              UIHelper.verticalSpace(16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  "Are you sure you want to Logout",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline16c666666tyleMontserratW600
                      .copyWith(color: AppColors.c1E1E1E, fontSize: 16.sp),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          width: double.infinity,
                          height: 45.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: AppColors.allPrimaryColor,
                          ),
                          // alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No",
                                style: TextFontStyle
                                    .headline16c666666tyleMontserratW700
                                    .copyWith(color: AppColors.cFFFFFF),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // UIHelper.horizontalSpace(10.w),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          width: double.infinity,
                          height: 45.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.allPrimaryColor,
                            ),
                          ),
                          // alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Yes",
                                style: TextFontStyle
                                    .headline16c666666tyleMontserratW700
                                    .copyWith(color: AppColors.c57AE8F),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(10.h),
              ],
            ),
          ],
        ),
  );
}

void showAccountDeleteDialog(BuildContext context) {
  showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
          ),
          title: Column(
            children: [
              UIHelper.verticalSpace(16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  "Are you sure you want to Delete Account",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline16c666666tyleMontserratW600
                      .copyWith(color: AppColors.c1E1E1E, fontSize: 16.sp),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          width: double.infinity,
                          height: 45.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: AppColors.allPrimaryColor,
                          ),
                          // alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No",
                                style: TextFontStyle
                                    .headline16c666666tyleMontserratW700
                                    .copyWith(color: AppColors.cFFFFFF),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // UIHelper.horizontalSpace(10.w),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          width: double.infinity,
                          height: 45.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.allPrimaryColor,
                            ),
                          ),
                          // alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Yes",
                                style: TextFontStyle
                                    .headline16c666666tyleMontserratW700
                                    .copyWith(color: AppColors.c57AE8F),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(10.h),
              ],
            ),
          ],
        ),
  );
}

double calculateCompletionPercentage({
  required int totalCourses,
  required int completedCourses,
}) {
  if (totalCourses == 0) {
    return 0; // Avoid division by zero
  }
  double percentage = (completedCourses * totalCourses) / 100;
  return percentage;
}
