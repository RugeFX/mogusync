import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_exception.dart';
import '../../core/state/app_providers.dart';
import 'data/auth_dto.dart';
import 'data/auth_repository.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.accessToken,
    this.errorMessage,
  });

  const AuthState.loading()
    : status = AuthStatus.loading,
      user = null,
      accessToken = null,
      errorMessage = null;

  const AuthState.unauthenticated({this.errorMessage})
    : status = AuthStatus.unauthenticated,
      user = null,
      accessToken = null;

  const AuthState.authenticated({required this.user, required this.accessToken})
    : status = AuthStatus.authenticated,
      errorMessage = null;

  final AuthStatus status;
  final ApiUser? user;
  final String? accessToken;
  final String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  bool _restoreStarted = false;

  @override
  AuthState build() {
    if (!_restoreStarted) {
      _restoreStarted = true;
      unawaited(_restore());
    }

    return const AuthState.loading();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      final response = await ref
          .read(authRepositoryProvider)
          .login(LoginRequest(email: email, password: password));
      await _persistAuth(response);
    } on ApiException catch (error) {
      state = AuthState.unauthenticated(errorMessage: error.message);
    } catch (_) {
      state = const AuthState.unauthenticated(
        errorMessage: 'Unable to login. Check the API server and try again.',
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    String? username,
  }) async {
    state = const AuthState.loading();
    try {
      final response = await ref
          .read(authRepositoryProvider)
          .register(
            RegisterRequest(
              email: email,
              password: password,
              username: username,
            ),
          );
      await _persistAuth(response);
    } on ApiException catch (error) {
      state = AuthState.unauthenticated(errorMessage: error.message);
    } catch (_) {
      state = const AuthState.unauthenticated(
        errorMessage: 'Unable to register. Check the API server and try again.',
      );
    }
  }

  Future<void> logout() async {
    await ref.read(tokenStoreProvider).clearAccessToken();
    state = const AuthState.unauthenticated();
  }

  Future<void> handleUnauthorized() async {
    await ref.read(tokenStoreProvider).clearAccessToken();
    state = const AuthState.unauthenticated(
      errorMessage: 'Your session expired. Please login again.',
    );
  }

  Future<void> _restore() async {
    final storedToken = await ref.read(tokenStoreProvider).readAccessToken();
    if (storedToken == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    try {
      final user = await ref
          .read(authRepositoryProvider)
          .fetchCurrentUser(accessToken: storedToken);
      state = AuthState.authenticated(user: user, accessToken: storedToken);
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await handleUnauthorized();
        return;
      }

      state = AuthState.unauthenticated(errorMessage: error.message);
    } catch (_) {
      state = const AuthState.unauthenticated(
        errorMessage: 'Unable to restore your session. Please login again.',
      );
    }
  }

  Future<void> _persistAuth(AuthResponse response) async {
    await ref.read(tokenStoreProvider).writeAccessToken(response.accessToken);
    state = AuthState.authenticated(
      user: response.user,
      accessToken: response.accessToken,
    );
  }
}
