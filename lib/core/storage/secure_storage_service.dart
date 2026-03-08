/// Contrato para persistencia de datos sensibles (tokens/credenciales).
abstract class SecureStorageService {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}
