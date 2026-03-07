import 'package:ev_products_app/core/storage/key_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<void> delete(String key) async {
    final prefs = await getSharedPreferencesInstance();
    await prefs.remove(key);
  }

  @override
  Future<T?> read<T>(String key) async {
    final prefs = await getSharedPreferencesInstance();
    switch (T) {
      case const (String):
        return await prefs.getString(key);
      case const (int):
        return await prefs.getInt(key);
      default:
        throw Exception('Tipo de dato no soportado');
    }
  }

  @override
  Future<void> write<T>(String key, T value) async {
    final prefs = await getSharedPreferencesInstance();

    switch (T) {
      case const (String):
        await prefs.setString(key, value as String);
        break;
      case const (int):
        await prefs.setInt(key, value as int);
        break;
      default:
        throw Exception('Tipo de dato no soportado');
    }
  }
}
