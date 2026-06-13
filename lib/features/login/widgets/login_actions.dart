import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/components/components.dart';
import '../../../core/theme/app_tokens.dart';
import '../login_credentials.dart';
import '../login_mode.dart';
import '../login_theme.dart';
import '../login_validators.dart';

class LoginActions extends StatelessWidget {
  const LoginActions({
    super.key,
    required this.mode,
    this.onDiscordLogin,
    this.onCredentialsLogin,
  });

  final LoginMode mode;
  final VoidCallback? onDiscordLogin;
  final ValueChanged<LoginCredentials>? onCredentialsLogin;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: switch (mode) {
        LoginMode.discord => DiscordLoginPanel(
          key: const ValueKey(LoginMode.discord),
          onPressed: onDiscordLogin,
        ),
        LoginMode.credentials => CredentialsLoginPanel(
          key: const ValueKey(LoginMode.credentials),
          onPressed: onCredentialsLogin,
        ),
      },
    );
  }
}

class DiscordLoginPanel extends StatelessWidget {
  const DiscordLoginPanel({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoginTagline(centered: true, mode: LoginMode.discord),
        const SizedBox(height: AppCoreTokens.lg),
        MogusyncButton(
          leading: const DiscordGlyph(),
          label: 'Login with Discord',
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class CredentialsLoginPanel extends StatefulWidget {
  const CredentialsLoginPanel({super.key, this.onPressed});

  final ValueChanged<LoginCredentials>? onPressed;

  @override
  State<CredentialsLoginPanel> createState() => _CredentialsLoginPanelState();
}

class _CredentialsLoginPanelState extends State<CredentialsLoginPanel> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    widget.onPressed?.call(
      LoginCredentials(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginTagline(centered: true, mode: LoginMode.credentials),
          const SizedBox(height: AppCoreTokens.md),
          MogusyncTextField(
            controller: _usernameController,
            label: 'Username',
            hint: 'Username',
            icon: LucideIcons.userRound,
            validator: LoginValidators.username,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),
          const SizedBox(height: AppCoreTokens.gutter),
          MogusyncTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            label: 'Password',
            hint: 'Password',
            icon: LucideIcons.lockKeyhole,
            obscureText: true,
            validator: LoginValidators.password,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppCoreTokens.md),
          MogusyncButton(label: 'Login', onPressed: _submit),
        ],
      ),
    );
  }
}

class LoginTagline extends StatelessWidget {
  const LoginTagline({super.key, required this.centered, required this.mode});

  final bool centered;
  final LoginMode mode;

  @override
  Widget build(BuildContext context) {
    final loginTheme = context.loginTheme;

    return RichText(
      textAlign: centered ? TextAlign.center : TextAlign.left,
      text: TextSpan(
        style: AppTypography.bodyLg.copyWith(
          color: loginTheme.textPrimary,
          height: 1.35,
        ),
        children: [
          TextSpan(
            text: mode == LoginMode.discord
                ? 'Connect to your discord account '
                : 'Enter your credentials ',
          ),
          if (centered) const TextSpan(text: '\nto get '),
          if (!centered) const TextSpan(text: 'to get '),
          TextSpan(
            text: 'cozy',
            style: TextStyle(
              color: loginTheme.accent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class DiscordGlyph extends StatelessWidget {
  const DiscordGlyph({super.key});

  @override
  Widget build(BuildContext context) {
    final loginTheme = context.loginTheme;

    return SvgPicture.asset(
      'assets/illustrations/discord.svg',
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(loginTheme.accentStrong, BlendMode.srcIn),
    );
  }
}
