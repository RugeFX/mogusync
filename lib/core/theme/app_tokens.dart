import 'package:flutter/material.dart';

abstract final class AppCoreTokens {
  static const surface = Color(0xFF190F23);
  static const surfaceDim = Color(0xFF190F23);
  static const surfaceBright = Color(0xFF41344B);
  static const surfaceContainerLowest = Color(0xFF14091E);
  static const surfaceContainerLow = Color(0xFF22172C);
  static const surfaceContainer = Color(0xFF261B30);
  static const surfaceContainerHigh = Color(0xFF31253B);
  static const surfaceContainerHighest = Color(0xFF3C3047);
  static const onSurface = Color(0xFFEFDCFA);
  static const onSurfaceVariant = Color(0xFFCBC4D0);
  static const inverseSurface = Color(0xFFEFDCFA);
  static const inverseOnSurface = Color(0xFF382C42);
  static const outline = Color(0xFF948E99);
  static const outlineVariant = Color(0xFF49454F);
  static const surfaceTint = Color(0xFFD3BCFC);
  static const primary = Color(0xFFD3BCFC);
  static const onPrimary = Color(0xFF38265B);
  static const primaryContainer = Color(0xFFB39DDB);
  static const onPrimaryContainer = Color(0xFF453268);
  static const inversePrimary = Color(0xFF68548D);
  static const secondary = Color(0xFFFFB1C7);
  static const onSecondary = Color(0xFF650032);
  static const secondaryContainer = Color(0xFF86204B);
  static const onSecondaryContainer = Color(0xFFFF9BBA);
  static const tertiary = Color(0xFFD4BFDC);
  static const onTertiary = Color(0xFF392B41);
  static const tertiaryContainer = Color(0xFFB4A1BC);
  static const onTertiaryContainer = Color(0xFF46374E);
  static const error = Color(0xFFFFB4AB);
  static const onError = Color(0xFF690005);
  static const errorContainer = Color(0xFF93000A);
  static const onErrorContainer = Color(0xFFFFDAD6);
  static const primaryFixed = Color(0xFFEBDCFF);
  static const primaryFixedDim = Color(0xFFD3BCFC);
  static const onPrimaryFixed = Color(0xFF230F45);
  static const onPrimaryFixedVariant = Color(0xFF503D73);
  static const secondaryFixed = Color(0xFFFFD9E2);
  static const secondaryFixedDim = Color(0xFFFFB1C7);
  static const onSecondaryFixed = Color(0xFF3E001C);
  static const onSecondaryFixedVariant = Color(0xFF831E48);
  static const tertiaryFixed = Color(0xFFF1DBF9);
  static const tertiaryFixedDim = Color(0xFFD4BFDC);
  static const onTertiaryFixed = Color(0xFF23162B);
  static const onTertiaryFixedVariant = Color(0xFF504158);
  static const background = Color(0xFF190F23);
  static const onBackground = Color(0xFFEFDCFA);
  static const surfaceVariant = Color(0xFF3C3047);
  static const white = Color(0xFFFFFFFF);

  static const xs = 4.0;
  static const base = 8.0;
  static const sm = 12.0;
  static const dflt = 16.0;
  static const md = 24.0;
  static const lg = 40.0;
  static const xl = 64.0;
  static const full = 9999.0;
  static const gutter = 16.0;
  static const marginMobile = 20.0;
  static const marginDesktop = 48.0;
}

abstract final class AppTypography {
  static const family = 'Inter';
  static const bodyFamily = family;

  static const displayLg = TextStyle(
    fontFamily: family,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );

  static const headlineLg = TextStyle(
    fontFamily: family,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const headlineLgMobile = TextStyle(
    fontFamily: family,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const titleLg = TextStyle(
    fontFamily: family,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static const bodyLg = TextStyle(
    fontFamily: family,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const bodyMd = TextStyle(
    fontFamily: family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const labelLg = TextStyle(
    fontFamily: family,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const labelSm = TextStyle(
    fontFamily: family,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: displayLg,
      headlineLarge: headlineLg,
      headlineMedium: headlineLgMobile,
      titleLarge: titleLg,
      bodyLarge: bodyLg,
      bodyMedium: bodyMd,
      labelLarge: labelLg,
      labelSmall: labelSm,
    ).apply(
      bodyColor: AppCoreTokens.onSurface,
      displayColor: AppCoreTokens.onSurface,
      fontFamily: family,
    );
  }
}
