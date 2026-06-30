import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/mogusync_api_client.dart';
import '../../../core/state/app_providers.dart';
import 'auth_dto.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(mogusyncApiClientProvider));
});

class AuthRepository {
  const AuthRepository(this._apiClient);

  final MogusyncApiClient _apiClient;

  Future<AuthResponse> register(RegisterRequest request) async {
    final json = await _apiClient.postJson(
      '/api/v1/auth/register',
      body: request.toJson(),
    );
    return AuthResponse.fromJson(json);
  }

  Future<AuthResponse> login(LoginRequest request) async {
    final json = await _apiClient.postJson(
      '/api/v1/auth/login',
      body: request.toJson(),
    );
    return AuthResponse.fromJson(json);
  }

  Future<ApiUser> fetchCurrentUser({required String accessToken}) async {
    final json = await _apiClient.getJson(
      '/api/v1/me',
      accessToken: accessToken,
    );
    return ApiUser.fromJson(json);
  }
}
