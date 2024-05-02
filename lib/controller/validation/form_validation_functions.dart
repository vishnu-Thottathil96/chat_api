class ValidationController {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? userNameValidator(String? value) {
    // Add your own logic for username validation if needed
    // For demo purposes, this just checks if the username is empty
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    // For demo purposes, let's consider a valid password to be at least 8 characters long
    if (value == null || value.isEmpty || value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String? password) {
    // For demo purposes, let's consider a valid password to be at least 8 characters long
    if (value == null || value.isEmpty || value != password) {
      return 'Passwords do not match. Please try again.';
    }
    return null;
  }
}
