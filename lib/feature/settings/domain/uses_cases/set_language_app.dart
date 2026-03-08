
import 'package:ev_products_app/feature/settings/domain/repositories/settings_repository.dart';

/// Caso de uso para actualizar idioma activo.
class SetLanguageApp {
  final SettingsRepository settingsRepository;

  SetLanguageApp(this.settingsRepository);

  Future<void> call(String language){
    return settingsRepository.setLanguage(language);
  }
}