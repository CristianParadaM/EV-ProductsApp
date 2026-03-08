import 'package:ev_products_app/feature/settings/domain/entities/settings.dart';
import 'package:flutter/material.dart';

/// Contrato de persistencia para preferencias de la aplicacion.
abstract class AbsSettingsDatasource {
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<void> setLanguage(String language);
  Future<Settings> getAppSettings();
}
