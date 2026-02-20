
String? nameValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Il nome è obbligatorio';
    }
    if (value.trim().length < 2) {
      return 'Il nome deve contenere almeno 2 caratteri';
    }
    final regex = RegExp(r'^[a-zA-ZÀ-ÿ\s]+$');
    if (!regex.hasMatch(value)) {
      return 'Il nome può contenere solo lettere e spazi';
    }
    return null;
  }

  String? emailValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'email è obbligatoria';
    }

    // Simple email regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Inserisci un indirizzo email valido';
    }

    return null;
  }

    String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "La password è obbligatoria";
    }
    if (value.length < 6) {
      return "La password deve contenere almeno 6 caratteri";
    }
    // Example rule: must contain a number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "La password deve contenere almeno un numero";
    }
    // // Example rule: must contain a special character
    // if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
    //   return "La password deve contenere almeno un carattere speciale";
    // }
    return null;
  }

  String? confirmPasswordValidation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return "La conferma password è obbligatoria";
    }
    if (value != password) {
      return "Le password non corrispondono";
    }
    return null;
  }
