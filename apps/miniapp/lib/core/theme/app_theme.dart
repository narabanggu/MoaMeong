import 'package:flutter/material.dart';
import 'package:miniapp/core/theme/app_palette.dart';

class AppTheme {
  AppTheme._();

  static const Color _primary = AppPalette.ink;
  static const Color _surface = AppPalette.paper;
  static const Color _background = AppPalette.background;
  static const Color _error = Color(0xFFD93A3A);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: _primary,
      secondary: AppPalette.inkSoft,
      tertiary: AppPalette.line,
      surface: _surface,
      surfaceContainerLow: _surface,
      surfaceContainerHighest: AppPalette.background,
      outline: AppPalette.lineStrong,
      onPrimary: AppPalette.white,
      onSurface: AppPalette.ink,
      error: _error,
    );

    final rounded12 = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
    final rounded16 = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    const fontFamilyName = 'SUIT';
    final baseTextTheme =
        ThemeData.light().textTheme.apply(fontFamily: fontFamilyName);
    final textTheme = baseTextTheme.copyWith(
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
        height: 1.22,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.15,
        height: 1.24,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
        height: 1.24,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        height: 1.36,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        height: 1.36,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        height: 1.34,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        letterSpacing: -0.1,
        height: 1.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamilyName,
      textTheme: textTheme,
      scaffoldBackgroundColor: _background,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppPalette.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: AppPalette.ink,
      ),
      cardTheme: CardThemeData(
        color: AppPalette.white,
        elevation: 0,
        shape: rounded16.copyWith(
          side: const BorderSide(
            color: AppPalette.line,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppPalette.white,
        elevation: 0,
        height: 68,
        indicatorColor: const Color(0xFFF0F2F5),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppPalette.ink,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppPalette.ink,
        foregroundColor: AppPalette.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppPalette.ink,
          foregroundColor: AppPalette.white,
          minimumSize: const Size(44, 46),
          shape: rounded12,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.ink,
          minimumSize: const Size(44, 44),
          shape: rounded12,
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPalette.ink,
          minimumSize: const Size(44, 44),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppPalette.white,
        selectedColor: Color(0xFFF6F7F9),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        side: BorderSide(color: AppPalette.line),
        labelStyle: TextStyle(
          color: AppPalette.ink,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.lineStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.lineStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.inkSoft, width: 1.6),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        labelStyle: const TextStyle(
          color: AppPalette.inkMuted,
          fontWeight: FontWeight.w600,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
