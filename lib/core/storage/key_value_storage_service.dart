/// Contrato key-value generico para configuraciones livianas de la app.
///
/// La API generica de lectura/escritura mantiene a los consumidores agnosticos
/// del motor de almacenamiento, con restricciones de tipo en la implementacion.
abstract class KeyValueStorageService {
  Future<T?> read<T>(String key);
  Future<void> write<T>(String key, T value);
  Future<void> delete(String key);
}
