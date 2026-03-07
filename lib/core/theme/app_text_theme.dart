import 'package:flutter/material.dart';

// Definición de la tipografía personalizada para la aplicación
class AppTextTheme {
  static TextTheme baseTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Títulos grandes
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
        letterSpacing: -0.5,
      ),

      // Títulos de secciones o nombres destacados
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),

      // Nombre en la lista/card
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        letterSpacing: 0.15,
      ),

      // Subtítulos o categorías
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant, // Un tono más suave
      ),

      // Cuerpo de texto principal (Descripciones)
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface,
        height: 1.5, // Interlineado para mejor lectura
      ),

      // Texto secundario (Metadata)
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurfaceVariant,
      ),

      // Etiquetas de botones
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: colorScheme.surface,
        letterSpacing: 1.25,
        textBaseline: TextBaseline.alphabetic,
      ),
    );
  }
}
