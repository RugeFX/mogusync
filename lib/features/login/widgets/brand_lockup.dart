import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_tokens.dart';
import '../login_theme.dart';

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final loginTheme = context.loginTheme;
    final logoSize = compact ? 132.0 : 160.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: logoSize,
          height: logoSize * 0.83,
          child: const MogusyncLogo(),
        ),
        SizedBox(height: compact ? AppCoreTokens.gutter : AppCoreTokens.md),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTypography.headlineLgMobile.copyWith(
              color: loginTheme.textPrimary,
              height: 1,
            ),
            children: [
              const TextSpan(text: 'mogu'),
              TextSpan(
                text: 'sync',
                style: TextStyle(color: loginTheme.accent),
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? AppCoreTokens.md : AppCoreTokens.lg),
        const BrandDivider(),
      ],
    );
  }
}

class BrandDivider extends StatelessWidget {
  const BrandDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final loginTheme = context.loginTheme;

    return SizedBox(
      width: 220,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.5,
              color: loginTheme.surfaceOutline.withValues(alpha: 0.25),
            ),
          ),
          Container(width: 88, height: 4, color: loginTheme.accent),
          Expanded(
            child: Container(
              height: 1.5,
              color: loginTheme.surfaceOutline.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }
}

class MogusyncLogo extends StatelessWidget {
  const MogusyncLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/brand/logo.svg',
      fit: BoxFit.contain,
      semanticsLabel: 'mogusync logo',
    );
  }
}
