import 'package:ev_products_app/feature/settings/data/data_sources/abs_settings_datasource.dart';
import 'package:ev_products_app/feature/settings/domain/entities/settings.dart';
import 'package:ev_products_app/feature/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class SettingsRepositoryImp extends SettingsRepository {
  final AbsSettingsDatasource datasource;

  SettingsRepositoryImp(this.datasource);

  @override
  Future<Settings> getAppSettings() {
    return datasource.getAppSettings();
  }

  @override
  Future<void> setLanguage(String language) async {
    await datasource.setLanguage(language);
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await datasource.setThemeMode(themeMode);
  }
}
