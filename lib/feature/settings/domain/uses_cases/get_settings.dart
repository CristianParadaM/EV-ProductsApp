
import 'package:ev_products_app/feature/settings/domain/entities/settings.dart';
import 'package:ev_products_app/feature/settings/domain/repositories/settings_repository.dart';

class GetSettings {
  final SettingsRepository settingsRepository;

  GetSettings(this.settingsRepository);
  
  Future<Settings> call() {
    return settingsRepository.getAppSettings();
  }
}