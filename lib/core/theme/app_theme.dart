import 'package:flutter/material.dart';

import '../../features/login/login_theme.dart';
import 'app_tokens.dart';

abstract final class MogusyncTheme {
  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppCoreTokens.primary,
      onPrimary: AppCoreTokens.onPrimary,
      primaryContainer: AppCoreTokens.primaryContainer,
      onPrimaryContainer: AppCoreTokens.onPrimaryContainer,
      secondary: AppCoreTokens.secondary,
      onSecondary: AppCoreTokens.onSecondary,
      secondaryContainer: AppCoreTokens.secondaryContainer,
      onSecondaryContainer: AppCoreTokens.onSecondaryContainer,
      tertiary: AppCoreTokens.tertiary,
      onTertiary: AppCoreTokens.onTertiary,
      tertiaryContainer: AppCoreTokens.tertiaryContainer,
      onTertiaryContainer: AppCoreTokens.onTertiaryContainer,
      error: AppCoreTokens.error,
      onError: AppCoreTokens.onError,
      errorContainer: AppCoreTokens.errorContainer,
      onErrorContainer: AppCoreTokens.onErrorContainer,
      surface: AppCoreTokens.surface,
      onSurface: AppCoreTokens.onSurface,
      surfaceContainerLowest: AppCoreTokens.surfaceContainerLowest,
      surfaceContainerLow: AppCoreTokens.surfaceContainerLow,
      surfaceContainer: AppCoreTokens.surfaceContainer,
      surfaceContainerHigh: AppCoreTokens.surfaceContainerHigh,
      surfaceContainerHighest: AppCoreTokens.surfaceContainerHighest,
      surfaceDim: AppCoreTokens.surfaceDim,
      surfaceBright: AppCoreTokens.surfaceBright,
      onSurfaceVariant: AppCoreTokens.onSurfaceVariant,
      outline: AppCoreTokens.outline,
      outlineVariant: AppCoreTokens.outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppCoreTokens.inverseSurface,
      onInverseSurface: AppCoreTokens.inverseOnSurface,
      inversePrimary: AppCoreTokens.inversePrimary,
      surfaceTint: AppCoreTokens.surfaceTint,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.bodyFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppCoreTokens.background,
      textTheme: AppTypography.textTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppCoreTokens.md),
          ),
          textStyle: const TextStyle(
            fontFamily: AppTypography.bodyFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppCoreTokens.dflt),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        MogusyncLoginTheme.defaultTheme,
      ],
    );
  }
}
