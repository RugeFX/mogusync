import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/app_tokens.dart';

enum MogusyncButtonVariant { primary, secondary, ghost }

enum MogusyncButtonSize { sm, md, lg }

class MogusyncButton extends StatelessWidget {
  const MogusyncButton({
    super.key,
    required this.label,
    this.variant = MogusyncButtonVariant.primary,
    this.size = MogusyncButtonSize.lg,
    this.leading,
    this.onPressed,
    this.fullWidth = true,
  });

  final String label;
  final MogusyncButtonVariant variant;
  final MogusyncButtonSize size;
  final Widget? leading;
  final VoidCallback? onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final colors = _ButtonColors.from(context, variant);
    final metrics = _ButtonMetrics.from(size);
    final enabled = onPressed != null;
    final foreground = enabled
        ? colors.foreground
        : colors.foreground.withValues(alpha: 0.62);
    final animationDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 140);

    final child = Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: PressableBox(
        enabled: enabled,
        enableFeedback: true,
        onPress: enabled ? onPressed : null,
        style: _buttonStyle(colors, metrics, animationDuration),
        child: IconTheme(
          data: IconThemeData(color: foreground, size: metrics.iconSize),
          child: DefaultTextStyle(
            style: metrics.textStyle.copyWith(color: foreground),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: metrics.gap),
                ],
                Flexible(child: Text(label)),
              ],
            ),
          ),
        ),
      ),
    );

    return SizedBox(width: fullWidth ? double.infinity : null, child: child);
  }

  BoxStyler _buttonStyle(
    _ButtonColors colors,
    _ButtonMetrics metrics,
    Duration animationDuration,
  ) {
    return BoxStyler()
        .minHeight(metrics.height)
        .paddingX(metrics.horizontalPadding)
        .alignment(Alignment.center)
        .color(colors.background)
        .borderRounded(metrics.radius)
        .animate(AnimationConfig.easeOut(animationDuration))
        .onHovered(BoxStyler().color(colors.hoverBackground).translate(0, -1))
        .onPressed(BoxStyler().color(colors.pressedBackground).scale(0.98))
        .onDisabled(BoxStyler().color(colors.disabledBackground));
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    required this.hoverBackground,
    required this.pressedBackground,
    required this.disabledBackground,
  });

  final Color background;
  final Color foreground;
  final Color hoverBackground;
  final Color pressedBackground;
  final Color disabledBackground;

  factory _ButtonColors.from(
    BuildContext context,
    MogusyncButtonVariant variant,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return switch (variant) {
      MogusyncButtonVariant.primary => _ButtonColors(
        background: colorScheme.primary,
        foreground: colorScheme.onPrimary,
        hoverBackground: colorScheme.primaryFixed,
        pressedBackground: colorScheme.primaryContainer,
        disabledBackground: colorScheme.primary.withValues(alpha: 0.54),
      ),
      MogusyncButtonVariant.secondary => _ButtonColors(
        background: colorScheme.surfaceContainerHighest,
        foreground: colorScheme.onSurface,
        hoverBackground: colorScheme.surfaceBright,
        pressedBackground: colorScheme.surfaceContainerHigh,
        disabledBackground: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.52,
        ),
      ),
      MogusyncButtonVariant.ghost => _ButtonColors(
        background: Colors.transparent,
        foreground: colorScheme.primary,
        hoverBackground: colorScheme.primary.withValues(alpha: 0.10),
        pressedBackground: colorScheme.primary.withValues(alpha: 0.16),
        disabledBackground: Colors.transparent,
      ),
    };
  }
}

class _ButtonMetrics {
  const _ButtonMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.radius,
    required this.iconSize,
    required this.gap,
    required this.textStyle,
  });

  final double height;
  final double horizontalPadding;
  final double radius;
  final double iconSize;
  final double gap;
  final TextStyle textStyle;

  factory _ButtonMetrics.from(MogusyncButtonSize size) {
    return switch (size) {
      MogusyncButtonSize.sm => const _ButtonMetrics(
        height: 44,
        horizontalPadding: AppCoreTokens.dflt,
        radius: AppCoreTokens.sm,
        iconSize: 18,
        gap: AppCoreTokens.base,
        textStyle: AppTypography.labelLg,
      ),
      MogusyncButtonSize.md => const _ButtonMetrics(
        height: 52,
        horizontalPadding: AppCoreTokens.md,
        radius: AppCoreTokens.sm,
        iconSize: 20,
        gap: AppCoreTokens.base,
        textStyle: AppTypography.labelLg,
      ),
      MogusyncButtonSize.lg => const _ButtonMetrics(
        height: AppCoreTokens.xl,
        horizontalPadding: AppCoreTokens.md,
        radius: AppCoreTokens.sm,
        iconSize: 24,
        gap: AppCoreTokens.sm,
        textStyle: AppTypography.labelLg,
      ),
    };
  }
}
