class RegisterRequest {
  const RegisterRequest({
    required this.email,
    required this.password,
    this.username,
  });

  final String email;
  final String password;
  final String? username;

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'password': password,
      if (username != null && username!.trim().isNotEmpty)
        'username': username!.trim(),
    };
  }
}

class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, Object?> toJson() {
    return {'email': email, 'password': password};
  }
}

class AuthResponse {
  const AuthResponse({
    required this.tokenType,
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, Object?> json) {
    return AuthResponse(
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      accessToken: json['accessToken'] as String,
      user: ApiUser.fromJson(json['user']! as Map<String, Object?>),
    );
  }

  final String tokenType;
  final String accessToken;
  final ApiUser user;
}

class ApiUser {
  const ApiUser({
    required this.id,
    required this.email,
    required this.username,
  });

  factory ApiUser.fromJson(Map<String, Object?> json) {
    return ApiUser(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
    );
  }

  final String id;
  final String email;
  final String username;
}
