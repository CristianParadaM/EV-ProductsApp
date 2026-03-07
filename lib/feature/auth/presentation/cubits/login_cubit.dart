import 'package:ev_products_app/feature/auth/domain/usesCases/check_login.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/login_credentials_use_case.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/login_facebook_use_case.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/login_google_use_case.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/logout_use_case.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/register_with_credentials_use_case.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<LoginState> {
  final LoginCredentialsUseCase loginCredentialsUseCase;
  final LogoutUseCase logoutUseCase;
  final LoginGoogleUseCase loginGoogleUseCase;
  final LoginFacebookUseCase loginFacebookUseCase;
  final CheckLoginUseCase checkLoginUseCase;
  final RegisterWithCredentialsUseCase registerWithCredentialsUseCase;

  AuthCubit(
    this.loginCredentialsUseCase,
    this.logoutUseCase,
    this.loginGoogleUseCase,
    this.loginFacebookUseCase,
    this.checkLoginUseCase,
    this.registerWithCredentialsUseCase,
  ) : super(LoginState.initial());

  Future<void> loginWithCredentials(String email, String password) async {
    emit(LoginState.loading());
    try {
      final user = await loginCredentialsUseCase(email, password);
      emit(LoginState.authenticated(user: user));
    } catch (e) {
      emit(LoginState.failure(error: e.toString()));
      throw Exception("Error en el login: ${e.toString()}");
    }
  }

  Future<void> logout() async {
    emit(LoginState.loading());
    try {
      await logoutUseCase();
      emit(LoginState.initial());
    } catch (e) {
      emit(LoginState.failure(error: e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginState.loading());
    try {
      final user = await loginGoogleUseCase();
      emit(LoginState.authenticated(user: user));
    } catch (e) {
      emit(LoginState.failure(error: e.toString()));
      throw Exception("Error iniciando sesion con google $e");
    }
  }

  Future<void> loginWithFacebook() async {
    emit(LoginState.loading());
    try {
      final user = await loginFacebookUseCase();
      emit(LoginState.authenticated(user: user));
    } catch (e) {
      emit(LoginState.failure(error: e.toString()));
      throw Exception("Error iniciando sesion con Facebook $e");
    }
  }

  Future<void> checkLogin() async {
    emit(LoginState.loading());
    try {
      final user = await checkLoginUseCase();
      if (user != null) {
        emit(LoginState.authenticated(user: user));
      } else {
        emit(LoginState.unauthenticated());
      }
    } catch (e) {
      emit(LoginState.failure(error: e.toString()));
    }
  }

  Future<void> registerWithCredentials(
    String fullName,
    String email,
    String password,
  ) async {
    emit(LoginState.loading());
    try {
      final user = await registerWithCredentialsUseCase(
        fullName,
        email,
        password,
      );
      emit(LoginState.registered(user: user));
    } catch (e) {
      emit(LoginState.failure(error: e.toString()));
      throw Exception("Error en el registro: ${e.toString()}");
    }
  }
}
