import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

final class ToastUtil {
  ToastUtil._();
  static void showLongToast(String message) {
    String trn = message.tr;
    Fluttertoast.showToast(msg: trn, toastLength: Toast.LENGTH_LONG);
  }

  static void showShortToast(String message) {
    Fluttertoast.showToast(msg: message.tr, toastLength: Toast.LENGTH_SHORT);
  }

  static void showNoInternetToast() {
    Fluttertoast.showToast(
      msg: "Please check your internet connection".tr,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void showNotLoggedInToast() {
    Fluttertoast.showToast(
      msg: "Please login to perform this operation".tr,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void showErrorShortToast(String message) {
    Fluttertoast.showToast(

      gravity: ToastGravity.TOP,


      msg: message.tr,

      backgroundColor: Colors.red,

      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
