import 'package:flutter/material.dart';

/// Entidad de dominio que agrupa preferencias globales de la app.
class Settings {
  final ThemeMode themeMode;
  final String language;

  Settings({required this.themeMode, required this.language});

  Settings copyWith({ThemeMode? themeMode, String? language}) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }
}
