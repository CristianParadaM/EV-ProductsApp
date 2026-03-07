import 'package:flutter/material.dart';

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
