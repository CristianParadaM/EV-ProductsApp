import 'package:ev_products_app/core/di/injector_container.dart';
import 'package:ev_products_app/feature/settings/data/data_sources/abs_settings_datasource.dart';
import 'package:ev_products_app/feature/settings/data/data_sources/settings_datasource.dart';
import 'package:ev_products_app/feature/settings/data/repositories/settings_repository_imp.dart';
import 'package:ev_products_app/feature/settings/domain/repositories/settings_repository.dart';
import 'package:ev_products_app/feature/settings/domain/uses_cases/get_settings.dart';
import 'package:ev_products_app/feature/settings/domain/uses_cases/set_language_app.dart';
import 'package:ev_products_app/feature/settings/domain/uses_cases/set_theme_app.dart';
import 'package:ev_products_app/feature/settings/presentation/cubits/settings_cubit.dart';
import 'package:get_it/get_it.dart';

void initSettingsFeature() {
  final GetIt instance = InjectorContainer.instance;

  instance.registerFactory(
    () => SettingsCubit(instance(), instance(), instance(), instance()),
  );

  instance.registerLazySingleton(() => GetSettings(instance()));
  instance.registerLazySingleton(() => SetLanguageApp(instance()));
  instance.registerLazySingleton(() => SetThemeApp(instance()));

  instance.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImp(instance()),
  );

  instance.registerLazySingleton<AbsSettingsDatasource>(
    () => SettingsDatasource(),
  );
}
