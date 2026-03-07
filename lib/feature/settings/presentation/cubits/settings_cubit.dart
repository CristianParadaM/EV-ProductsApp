import 'package:ev_products_app/core/storage/key_value_storage_service.dart';
import 'package:ev_products_app/feature/settings/domain/entities/settings.dart';
import 'package:ev_products_app/feature/settings/domain/uses_cases/get_settings.dart';
import 'package:ev_products_app/feature/settings/domain/uses_cases/set_language_app.dart';
import 'package:ev_products_app/feature/settings/domain/uses_cases/set_theme_app.dart';
import 'package:ev_products_app/feature/settings/presentation/cubits/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettings getSettings;
  final SetLanguageApp setLanguageApp;
  final SetThemeApp setThemeApp;
  final KeyValueStorageService _keyValueStorageService;

  SettingsCubit(
    this.getSettings,
    this.setLanguageApp,
    this.setThemeApp,
    this._keyValueStorageService,
  ) : super(SettingsState.initial());

  Future<void> load() async {
    emit(const SettingsState.loading());
    try {
      final localIndex = await _keyValueStorageService.read<int>('localIndex');
      final languageLocal = await _keyValueStorageService.read<String>(
        'language',
      );
      if (languageLocal != null && localIndex != null) {
        final safeIndex = localIndex.clamp(0, ThemeMode.values.length - 1);
        emit(
          SettingsState.loaded(
            settings: Settings(
              themeMode: ThemeMode.values[safeIndex],
              language: languageLocal,
            ),
          ),
        );
      } else {
        final settings = await getSettings();
        emit(SettingsState.loaded(settings: settings));
      }
    } catch (e) {
      emit(SettingsState.error(message: e.toString()));
    }
  }

  Future<void> changeLanguage(String newLanguage) async {
    try {
      await _keyValueStorageService.write('language', newLanguage);
      await setLanguageApp(newLanguage);
      load();
    } catch (e) {
      emit(SettingsState.error(message: e.toString()));
    }
  }

  Future<void> changeTheme(ThemeMode newTheme) async {
    try {
      await _keyValueStorageService.write('localIndex', newTheme.index);
      await setThemeApp(newTheme);
      load();
    } catch (e) {
      emit(SettingsState.error(message: e.toString()));
    }
  }
}
