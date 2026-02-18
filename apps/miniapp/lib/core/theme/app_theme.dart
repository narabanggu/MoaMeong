import 'package:flutter/material.dart';
import 'package:miniapp/core/theme/app_palette.dart';

class AppTheme {
  AppTheme._();

  static const Color _primary = AppPalette.yellow;
  static const Color _surface = AppPalette.paper;
  static const Color _background = AppPalette.background;
  static const Color _error = Color(0xFFD93A3A);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: _primary,
      secondary: AppPalette.orange,
      tertiary: AppPalette.yellowSoft,
      surface: _surface,
      onPrimary: AppPalette.ink,
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

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamilyName,
      textTheme: baseTextTheme,
      scaffoldBackgroundColor: _background,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppPalette.ink,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.7),
        elevation: 0,
        shape: rounded16,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.64),
        elevation: 0,
        height: 66,
        indicatorColor: AppPalette.yellowSoft.withValues(alpha: 0.96),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppPalette.ink,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppPalette.yellow,
        foregroundColor: AppPalette.ink,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppPalette.yellow,
          foregroundColor: AppPalette.ink,
          minimumSize: const Size(44, 44),
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
      chipTheme: ChipThemeData(
        backgroundColor: AppPalette.yellowPale.withValues(alpha: 0.95),
        selectedColor: AppPalette.yellowSoft.withValues(alpha: 0.95),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        side: BorderSide(color: AppPalette.line.withValues(alpha: 0.6)),
        labelStyle: const TextStyle(
          color: AppPalette.ink,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.82),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppPalette.line.withValues(alpha: 0.75),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppPalette.line.withValues(alpha: 0.7),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.orange, width: 1.6),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
