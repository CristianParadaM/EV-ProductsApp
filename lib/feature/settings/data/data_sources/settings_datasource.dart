import 'package:ev_products_app/feature/settings/data/data_sources/abs_settings_datasource.dart';
import 'package:ev_products_app/feature/settings/domain/entities/settings.dart';
import 'package:flutter/material.dart';

/// Implementacion base de ajustes.
///
/// Actualmente retorna valores por defecto; la persistencia real se controla en
/// cubit mediante almacenamiento local.
class SettingsDatasource extends AbsSettingsDatasource {
  @override
  Future<Settings> getAppSettings() async {
    return Settings(themeMode: ThemeMode.light, language: 'en');
  }

  @override
  Future<void> setLanguage(String language) async {}

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {}
  
}
