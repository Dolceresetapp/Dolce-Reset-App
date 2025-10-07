import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  //Confirm Password

  bool _confirmPasswordVisible = false;
  bool get confirmPasswordVisible => _confirmPasswordVisible;
  void toggleConfirmPasswordVisibility() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }
}
