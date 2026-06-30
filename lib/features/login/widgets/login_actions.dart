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
    this.isSubmitting = false,
    this.errorMessage,
    this.onDiscordLogin,
    this.onCredentialsLogin,
    this.onCredentialsRegister,
  });

  final LoginMode mode;
  final bool isSubmitting;
  final String? errorMessage;
  final VoidCallback? onDiscordLogin;
  final Future<void> Function(LoginCredentials credentials)? onCredentialsLogin;
  final Future<void> Function(LoginCredentials credentials)?
  onCredentialsRegister;

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
          isSubmitting: isSubmitting,
          errorMessage: errorMessage,
          onLogin: onCredentialsLogin,
          onRegister: onCredentialsRegister,
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
  const CredentialsLoginPanel({
    super.key,
    this.isSubmitting = false,
    this.errorMessage,
    this.onLogin,
    this.onRegister,
  });

  final bool isSubmitting;
  final String? errorMessage;
  final Future<void> Function(LoginCredentials credentials)? onLogin;
  final Future<void> Function(LoginCredentials credentials)? onRegister;

  @override
  State<CredentialsLoginPanel> createState() => _CredentialsLoginPanelState();
}

class _CredentialsLoginPanelState extends State<CredentialsLoginPanel> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  var _autovalidateMode = AutovalidateMode.disabled;
  var _isRegistering = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final credentials = LoginCredentials(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      username: _usernameController.text.trim(),
    );

    if (_isRegistering) {
      await widget.onRegister?.call(credentials);
      return;
    }

    await widget.onLogin?.call(
      LoginCredentials(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _isRegistering = !_isRegistering;
      _autovalidateMode = AutovalidateMode.disabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            controller: _emailController,
            label: 'Email',
            hint: 'Email',
            icon: LucideIcons.mail,
            validator: LoginValidators.email,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              if (_isRegistering) {
                _usernameFocusNode.requestFocus();
                return;
              }

              _passwordFocusNode.requestFocus();
            },
          ),
          const SizedBox(height: AppCoreTokens.gutter),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: _isRegistering
                ? Padding(
                    key: const ValueKey('register-username-field'),
                    padding: const EdgeInsets.only(
                      bottom: AppCoreTokens.gutter,
                    ),
                    child: MogusyncTextField(
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      label: 'Username',
                      hint: 'Optional username',
                      icon: LucideIcons.userRound,
                      validator: LoginValidators.optionalUsername,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          _passwordFocusNode.requestFocus(),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('login-username-field')),
          ),
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
          if (widget.errorMessage != null) ...[
            const SizedBox(height: AppCoreTokens.sm),
            Text(
              widget.errorMessage!,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd.copyWith(color: colorScheme.error),
            ),
          ],
          const SizedBox(height: AppCoreTokens.md),
          MogusyncButton(
            label: widget.isSubmitting
                ? 'Please wait...'
                : _isRegistering
                ? 'Register'
                : 'Login',
            onPressed: widget.isSubmitting ? null : _submit,
          ),
          const SizedBox(height: AppCoreTokens.base),
          TextButton(
            onPressed: widget.isSubmitting ? null : _toggleMode,
            child: Text(
              _isRegistering
                  ? 'Already have an account? Login'
                  : 'Need an account? Register',
            ),
          ),
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
