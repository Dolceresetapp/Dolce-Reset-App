
String? nameValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (!regex.hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null; 
  }

  String? emailValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    // Simple email regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null; 
  }

    String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    // Example rule: must contain a number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one number";
    }
    // // Example rule: must contain a special character
    // if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
    //   return "Password must contain at least one special character";
    // }
    return null;
  }

  String? confirmPasswordValidation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return "Confirm password is required";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null; 
  }