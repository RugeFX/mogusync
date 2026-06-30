import 'package:flutter/foundation.dart';

@immutable
class LoginCredentials {
  const LoginCredentials({
    required this.email,
    required this.password,
    this.username,
  });

  final String email;
  final String password;
  final String? username;
}
