abstract final class LoginValidators {
  static String? email(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? optionalUsername(String? value) {
    final username = value?.trim() ?? '';

    if (username.isEmpty) {
      return null;
    }

    if (username.length > 64) {
      return 'Username must be 64 characters or fewer';
    }

    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }
}
