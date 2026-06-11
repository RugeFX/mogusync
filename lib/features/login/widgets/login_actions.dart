import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
        const LoginTagline(centered: true),
        const SizedBox(height: AppCoreTokens.lg),
        PrimaryLoginButton(
          icon: const DiscordGlyph(),
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
          const LoginTagline(centered: true),
          const SizedBox(height: AppCoreTokens.md),
          LoginTextField(
            controller: _usernameController,
            label: 'Username',
            hint: 'Username',
            icon: LucideIcons.userRound,
            validator: LoginValidators.username,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),
          const SizedBox(height: AppCoreTokens.gutter),
          LoginTextField(
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
          PrimaryLoginButton(label: 'Login', onPressed: _submit),
        ],
      ),
    );
  }
}

class LoginTagline extends StatelessWidget {
  const LoginTagline({super.key, required this.centered});

  final bool centered;

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
          const TextSpan(text: 'Connect to your discord account '),
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

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.focusNode,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final loginTheme = context.loginTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            color: loginTheme.textPrimary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppCoreTokens.base),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          cursorColor: loginTheme.accent,
          style: AppTypography.bodyLg.copyWith(color: loginTheme.textPrimary),
          validator: validator,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            filled: true,
            fillColor: loginTheme.surface,
            hintText: hint,
            hintStyle: AppTypography.bodyLg.copyWith(
              color: loginTheme.textMuted,
            ),
            prefixIcon: Icon(icon, color: loginTheme.accent, size: 24),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 56,
              minHeight: 52,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppCoreTokens.gutter,
              vertical: AppCoreTokens.sm,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppCoreTokens.dflt),
              borderSide: BorderSide(
                color: loginTheme.surfaceOutline,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppCoreTokens.dflt),
              borderSide: BorderSide(color: loginTheme.accent, width: 2.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppCoreTokens.dflt),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppCoreTokens.dflt),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2.5,
              ),
            ),
            errorStyle: AppTypography.labelSm.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}

class PrimaryLoginButton extends StatelessWidget {
  const PrimaryLoginButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final loginTheme = context.loginTheme;

    return SizedBox(
      width: double.infinity,
      height: AppCoreTokens.xl,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: loginTheme.accent,
          foregroundColor: loginTheme.accentStrong,
          disabledBackgroundColor: loginTheme.accent.withValues(alpha: 0.74),
          disabledForegroundColor: loginTheme.accentStrong.withValues(
            alpha: 0.86,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppCoreTokens.md),
          ),
          textStyle: AppTypography.labelLg,
        ),
        onPressed: onPressed ?? () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: AppCoreTokens.sm),
            ],
            Flexible(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscordGlyph extends StatelessWidget {
  const DiscordGlyph({super.key});

  @override
  Widget build(BuildContext context) {
    final loginTheme = context.loginTheme;

    return SizedBox(
      width: 50,
      height: 32,
      child: CustomPaint(
        painter: _DiscordGlyphPainter(
          foreground: loginTheme.accentStrong,
          background: loginTheme.accent,
        ),
      ),
    );
  }
}

class _DiscordGlyphPainter extends CustomPainter {
  const _DiscordGlyphPainter({
    required this.foreground,
    required this.background,
  });

  final Color foreground;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = foreground
      ..style = PaintingStyle.fill;

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.06,
        size.height * 0.10,
        size.width * 0.88,
        size.height * 0.72,
      ),
      Radius.circular(size.width * 0.24),
    );
    canvas.drawRRect(body, paint);

    final leftEar = Path()
      ..moveTo(size.width * 0.18, size.height * 0.12)
      ..lineTo(size.width * 0.27, 0)
      ..lineTo(size.width * 0.38, size.height * 0.14)
      ..close();
    final rightEar = Path()
      ..moveTo(size.width * 0.62, size.height * 0.14)
      ..lineTo(size.width * 0.73, 0)
      ..lineTo(size.width * 0.82, size.height * 0.12)
      ..close();
    canvas.drawPath(leftEar, paint);
    canvas.drawPath(rightEar, paint);

    final cutoutPaint = Paint()
      ..color = background
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.46),
      size.width * 0.07,
      cutoutPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.46),
      size.width * 0.07,
      cutoutPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.50, size.height * 0.94),
        width: size.width * 0.68,
        height: size.height * 0.34,
      ),
      cutoutPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DiscordGlyphPainter oldDelegate) {
    return oldDelegate.foreground != foreground ||
        oldDelegate.background != background;
  }
}
