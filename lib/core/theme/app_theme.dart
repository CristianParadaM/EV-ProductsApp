import 'package:ev_products_app/core/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

// Definición de los temas de la aplicación
class AppTheme {
  static const Color _lightPrimary = Colors.deepOrange;
  static const Color _darkPrimary = Color(0xFFFF8A65);
  static const Color _lightSecondary = Colors.orange;
  static const Color _darkSecondary = Color(0xFFFFB74D);
  static const Color _lightCanvas = Color.fromARGB(255, 234, 234, 234);
  static const Color _iconSelected = Colors.white;
  static const Color _iconUnselectedLight = Colors.black;
  static const Color _iconUnselectedDark = Color(0xFFBDBDBD);

  static final ColorScheme _lightColorScheme =
      ColorScheme.fromSeed(
        seedColor: _lightPrimary,
        brightness: Brightness.light,
      ).copyWith(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
      );

  static final ColorScheme _darkColorScheme =
      ColorScheme.fromSeed(
        seedColor: _darkPrimary,
        brightness: Brightness.dark,
      ).copyWith(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
      );

  // Método privado para construir el tema a partir de un esquema de colores
  static ThemeData _buildTheme(
    ColorScheme colorScheme,
    Color scaffoldBackgroundColor,
    Color canvasColor,
    Color iconUnselectedColor,
    Color splashColor,
  ) {
    return ThemeData(
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      canvasColor: canvasColor,
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.baseTextTheme(colorScheme),
      splashColor: splashColor,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary.withValues(alpha: 0.20);
            }
            return colorScheme.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.onSurface;
          }),
          side: WidgetStatePropertyAll(
            BorderSide(color: colorScheme.outlineVariant),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.onPrimary,
        indicatorColor: colorScheme.onPrimary,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _iconSelected);
          }
          return IconThemeData(color: iconUnselectedColor);
        }),
      ),
    );
  }

  // Temas claros de la aplicación utilizando el método de construcción
  static final ThemeData lightTheme = _buildTheme(
    _lightColorScheme,
    const Color(0xFFF8FAFC),
    _lightCanvas,
    _iconUnselectedLight,
    const Color(0xFFF6E3ED),
  );

  // Temas oscuros de la aplicación utilizando el método de construcción
  static final ThemeData darkTheme = _buildTheme(
    _darkColorScheme,
    const Color(0xFF121212),
    const Color(0xFF1E1E1E),
    _iconUnselectedDark,
    const Color(0xFFF6E3ED),
  );
}
