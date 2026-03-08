import 'package:ev_products_app/feature/settings/domain/entities/settings.dart';
import 'package:flutter/material.dart';

/// Contrato de acceso para lectura y escritura de preferencias.
abstract class SettingsRepository {
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<void> setLanguage(String language);
  Future<Settings> getAppSettings();
}
