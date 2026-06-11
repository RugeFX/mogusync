import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

@immutable
class MogusyncLoginTheme extends ThemeExtension<MogusyncLoginTheme> {
  const MogusyncLoginTheme({
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.backgroundGlow,
    required this.surface,
    required this.surfaceOutline,
    required this.textPrimary,
    required this.textMuted,
    required this.accent,
    required this.accentSoft,
    required this.accentStrong,
    required this.waveDot,
    required this.waveDotBright,
  });

  final Color backgroundTop;
  final Color backgroundBottom;
  final Color backgroundGlow;
  final Color surface;
  final Color surfaceOutline;
  final Color textPrimary;
  final Color textMuted;
  final Color accent;
  final Color accentSoft;
  final Color accentStrong;
  final Color waveDot;
  final Color waveDotBright;

  static const defaultTheme = MogusyncLoginTheme(
    backgroundTop: AppCoreTokens.surfaceContainerHigh,
    backgroundBottom: AppCoreTokens.surface,
    backgroundGlow: Color(0x33D3BCFC),
    surface: AppCoreTokens.surfaceBright,
    surfaceOutline: AppCoreTokens.primary,
    textPrimary: AppCoreTokens.onSurface,
    textMuted: AppCoreTokens.onSurfaceVariant,
    accent: AppCoreTokens.primary,
    accentSoft: AppCoreTokens.primaryFixed,
    accentStrong: AppCoreTokens.onPrimary,
    waveDot: Color(0x6649454F),
    waveDotBright: AppCoreTokens.primaryFixedDim,
  );

  @override
  MogusyncLoginTheme copyWith({
    Color? backgroundTop,
    Color? backgroundBottom,
    Color? backgroundGlow,
    Color? surface,
    Color? surfaceOutline,
    Color? textPrimary,
    Color? textMuted,
    Color? accent,
    Color? accentSoft,
    Color? accentStrong,
    Color? waveDot,
    Color? waveDotBright,
  }) {
    return MogusyncLoginTheme(
      backgroundTop: backgroundTop ?? this.backgroundTop,
      backgroundBottom: backgroundBottom ?? this.backgroundBottom,
      backgroundGlow: backgroundGlow ?? this.backgroundGlow,
      surface: surface ?? this.surface,
      surfaceOutline: surfaceOutline ?? this.surfaceOutline,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      accentStrong: accentStrong ?? this.accentStrong,
      waveDot: waveDot ?? this.waveDot,
      waveDotBright: waveDotBright ?? this.waveDotBright,
    );
  }

  @override
  MogusyncLoginTheme lerp(ThemeExtension<MogusyncLoginTheme>? other, double t) {
    if (other is! MogusyncLoginTheme) {
      return this;
    }

    return MogusyncLoginTheme(
      backgroundTop: Color.lerp(backgroundTop, other.backgroundTop, t)!,
      backgroundBottom: Color.lerp(
        backgroundBottom,
        other.backgroundBottom,
        t,
      )!,
      backgroundGlow: Color.lerp(backgroundGlow, other.backgroundGlow, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceOutline: Color.lerp(surfaceOutline, other.surfaceOutline, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      accentStrong: Color.lerp(accentStrong, other.accentStrong, t)!,
      waveDot: Color.lerp(waveDot, other.waveDot, t)!,
      waveDotBright: Color.lerp(waveDotBright, other.waveDotBright, t)!,
    );
  }
}

extension MogusyncLoginThemeLookup on BuildContext {
  MogusyncLoginTheme get loginTheme {
    return Theme.of(this).extension<MogusyncLoginTheme>() ??
        MogusyncLoginTheme.defaultTheme;
  }
}
