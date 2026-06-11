import 'package:flutter/foundation.dart';

@immutable
class LoginCredentials {
  const LoginCredentials({required this.username, required this.password});

  final String username;
  final String password;
}
