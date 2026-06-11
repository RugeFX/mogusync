import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import 'login_credentials.dart';
import 'login_mode.dart';
import 'login_theme.dart';
import 'widgets/brand_lockup.dart';
import 'widgets/login_actions.dart';
import 'widgets/sound_wave_background.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
    this.mode = LoginMode.credentials,
    this.onDiscordLogin,
    this.onCredentialsLogin,
  });

  final LoginMode mode;
  final VoidCallback? onDiscordLogin;
  final ValueChanged<LoginCredentials>? onCredentialsLogin;

  @override
  Widget build(BuildContext context) {
    final loginTheme = context.loginTheme;

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
                            onDiscordLogin: onDiscordLogin,
                            onCredentialsLogin: onCredentialsLogin,
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
