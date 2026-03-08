import 'dart:async';

import 'package:ev_products_app/feature/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:ev_products_app/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:ev_products_app/feature/auth/data/mappers/user_mapper.dart';
import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';
import 'package:ev_products_app/feature/auth/domain/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDatasource datasource;
  final AuthLocalDatasource datasourceLocal;

  AuthRepositoryImpl(this.datasource, this.datasourceLocal);

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
  Future<UserApp> loginWithCredentials(String email, String password) async {
    try {
      return await datasource
          .signInWithEmailAndPassword(email, password)
          .timeout(const Duration(seconds: 8));
    } catch (e) {
      return datasourceLocal.loginWithEmailAndPassword(email, password);
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
  ) async {
    try {
      final user = await datasource.registerWithEmailAndPassword(fullName, email, password);
      await datasourceLocal.saveUser(UserMapper.domainToModel(user, password));
      return user;
    } catch (e) {
      throw Exception('Error en registerWithCredentials: ${e.toString()}');
    }
  }
}
