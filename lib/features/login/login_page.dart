import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/router/app_routes.dart';
import '../auth/auth_controller.dart';
import 'login_credentials.dart';
import 'login_mode.dart';
import 'login_theme.dart';
import 'widgets/brand_lockup.dart';
import 'widgets/login_actions.dart';
import 'widgets/sound_wave_background.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({
    super.key,
    this.mode = LoginMode.credentials,
    this.onDiscordLogin,
  });

  final LoginMode mode;
  final VoidCallback? onDiscordLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginTheme = context.loginTheme;
    final authState = ref.watch(authControllerProvider);

    if (authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(AppRoutes.queue);
        }
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.65, 1],
            colors: [
              loginTheme.backgroundTop,
              loginTheme.backgroundBottom,
              loginTheme.backgroundBottom,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _BackgroundGlow(),
            const Align(
              alignment: Alignment.bottomCenter,
              child: SoundWaveBackground(),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxHeight < 720;

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppCoreTokens.marginMobile,
                      isCompact ? AppCoreTokens.lg : AppCoreTokens.xl,
                      AppCoreTokens.marginMobile,
                      AppCoreTokens.lg,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight -
                            (isCompact ? AppCoreTokens.xl : 104),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BrandLockup(compact: isCompact),
                          SizedBox(
                            height: isCompact
                                ? AppCoreTokens.md
                                : AppCoreTokens.lg,
                          ),
                          LoginActions(
                            mode: mode,
                            isSubmitting: authState.isLoading,
                            errorMessage: authState.errorMessage,
                            onDiscordLogin: onDiscordLogin,
                            onCredentialsLogin: (credentials) =>
                                _handleLogin(context, ref, credentials),
                            onCredentialsRegister: (credentials) =>
                                _handleRegister(context, ref, credentials),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin(
    BuildContext context,
    WidgetRef ref,
    LoginCredentials credentials,
  ) async {
    await ref
        .read(authControllerProvider.notifier)
        .login(email: credentials.email, password: credentials.password);

    if (context.mounted && ref.read(authControllerProvider).isAuthenticated) {
      context.go(AppRoutes.queue);
    }
  }

  Future<void> _handleRegister(
    BuildContext context,
    WidgetRef ref,
    LoginCredentials credentials,
  ) async {
    await ref
        .read(authControllerProvider.notifier)
        .register(
          email: credentials.email,
          password: credentials.password,
          username: credentials.username,
        );

    if (context.mounted && ref.read(authControllerProvider).isAuthenticated) {
      context.go(AppRoutes.queue);
    }
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    final loginTheme = context.loginTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.72),
          radius: 0.82,
          colors: [loginTheme.backgroundGlow, Colors.transparent],
        ),
      ),
    );
  }
}
