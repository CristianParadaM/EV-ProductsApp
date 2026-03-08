import 'dart:convert';
import 'package:ev_products_app/core/storage/sqlite_key_value_cache.dart';
import 'package:ev_products_app/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:ev_products_app/feature/auth/data/mappers/user_mapper.dart';
import 'package:ev_products_app/feature/auth/data/models/user_model.dart';
import 'package:ev_products_app/feature/auth/data/security/password_hasher.dart';
import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';

/// Implementacion local de autenticacion respaldada en SQLite key-value.
///
/// Se usa como fallback cuando el login remoto falla o no hay conectividad.
class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  final SqliteKeyValueCache _storage;

  AuthLocalDatasourceImpl(this._storage) {
    registerDefaultUser();
  }

  /// Crea un usuario semilla para pruebas solo si no existe previamente.
  Future<void> registerDefaultUser() async {
    final rawUser = await _storage.readString('user_admin@evertec.com');
    if (rawUser != null) {
      return; // El usuario ya existe, no es necesario registrarlo
    }
    final defaultUser = UserMapper.domainToModel(
      UserApp(id: '20260307', email: 'admin@evertec.com', name: 'Evertec Default User'),
      'Pruebas123*',
    );
    await saveUser(defaultUser);
  }

  @override
  Future<UserApp> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Se normaliza email para evitar claves distintas por mayusculas/espacios.
    final normalizedEmail = email.trim().toLowerCase();
    final rawUser = await _storage.readString('user_$normalizedEmail');

    if (rawUser == null) {
      throw Exception('Usuario no encontrado');
    }

    final userJson = jsonDecode(rawUser) as Map<String, dynamic>;
    final user = UserModel.fromJson(userJson);

    final isValidPassword = PasswordHasher.verifyPassword(
      password: password,
      encodedHash: user.password,
    );

    if (!isValidPassword) {
      throw Exception('Credenciales inválidas');
    }

    return UserApp(id: user.id, email: user.email, name: user.name);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'password': user.password,
    });

    await _storage.writeString(
      'user_${user.email.trim().toLowerCase()}',
      userJson,
    );
  }
}
