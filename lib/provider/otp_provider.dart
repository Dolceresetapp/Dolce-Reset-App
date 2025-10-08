import 'package:flutter/material.dart';

class OtpProvider with ChangeNotifier {
  String _enteredOtp = '';

  String get enteredOtp => _enteredOtp;

  bool _isOtpInvalid = false;
  bool get isOtpInvalid => _isOtpInvalid;

  void setOtpInvalid(bool value) {
    _isOtpInvalid = value;
    notifyListeners();
  }

  void validateOtp(String pin) {
    if (pin.length != 4) {
      setOtpInvalid(true);
    } else {
      setOtpInvalid(false);
    }
  }

  void updateOtp(String pin) {
    if (pin.length == 4) {
      setOtpInvalid(false);
      _enteredOtp = pin;
    } else {
      setOtpInvalid(true);
    }
  }

   void resetOtp() {
    _enteredOtp = '';
    _isOtpInvalid = false;
    notifyListeners();
  }
}