import 'package:ev_products_app/feature/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class SetThemeApp {
  final SettingsRepository settingsRepository;

  SetThemeApp(this.settingsRepository);

  Future<void> call(ThemeMode themeMode) {
    return settingsRepository.setThemeMode(themeMode);
  }
}
