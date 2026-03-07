
import 'package:ev_products_app/feature/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';
import 'package:ev_products_app/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserApp> loginFacebook() {
    try {
      return datasource.signInWithFacebook();
    } catch (e) {
      throw Exception('Error en login con Facebook: ${e.toString()}');
    }
  }

  @override
  Future<UserApp> loginGoogle() {
    try {
      return datasource.signInWithGoogle();
    } catch (e) {
      throw Exception('Error en login con Google: ${e.toString()}');
    }
  }

  @override
  Future<UserApp> loginWithCredentials(String email, String password) {
    try {
      return datasource.signInWithEmailAndPassword(email, password);
    } catch (e) {
      throw Exception('Error en login con email y contraseña: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await datasource.signOut();
    } catch (e) {
      throw Exception('Error en logout: ${e.toString()}');
    }
  }

  @override
  Future<UserApp?> checkLogin() {
    try {
      return datasource.checkLogin();
    } catch (e) {
      throw Exception('Error en checkLogin: ${e.toString()}');
    }
  }

  @override
  Future<UserApp> registerWithCredentials(
    String fullName,
    String email,
    String password,
  ) {
    try {
      return datasource.registerWithEmailAndPassword(fullName, email, password);
    } catch (e) {
      throw Exception('Error en registerWithCredentials: ${e.toString()}');
    }
  }
}
