import 'package:ev_products_app/core/storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Adaptador sobre `FlutterSecureStorage` para aislar infraestructura de las
/// capas de feature/dominio.
class SecureStorageServiceImpl extends SecureStorageService {
  final FlutterSecureStorage secureStorage;

  SecureStorageServiceImpl(this.secureStorage);

  @override
  Future<void> delete(String key) async {
    await secureStorage.delete(key: key);
  }

  @override
  Future<String?> read(String key) async {
    return await secureStorage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }
}
