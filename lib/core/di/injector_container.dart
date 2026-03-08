import 'package:ev_products_app/core/http/client_api.dart';
import 'package:ev_products_app/core/storage/key_value_storage_service.dart';
import 'package:ev_products_app/core/storage/key_value_storage_service_impl.dart';
import 'package:ev_products_app/core/storage/secure_storage_service.dart';
import 'package:ev_products_app/core/storage/secure_storage_service_impl.dart';
import 'package:ev_products_app/feature/auth/auth_di.dart';
import 'package:ev_products_app/feature/layout/presentation/layout_di.dart';
import 'package:ev_products_app/feature/products/products_di.dart';
import 'package:ev_products_app/feature/settings/settings_di.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InjectorContainer {
  InjectorContainer._();

  static final GetIt instance = GetIt.instance;

  static Future<void> init() async {
    _registerExternalDependencies();
    _registerCore();
    _registerFeatures();
  }

  static void _registerExternalDependencies() {
    // Almacenamiento seguro
    instance.registerLazySingleton(() => const FlutterSecureStorage());
  }

  static void _registerCore() {
    instance.registerLazySingleton<KeyValueStorageService>(
      () => KeyValueStorageServiceImpl(),
    );
    instance.registerLazySingleton<SecureStorageService>(
      () => SecureStorageServiceImpl(instance()),
    );
    instance.registerLazySingleton(() => ClientApi());
  }

  static void _registerFeatures() {
    initAuthFeature();
    initLayoutFeature();
    initSettingsFeature();
    initProductsFeature();
  }
}
