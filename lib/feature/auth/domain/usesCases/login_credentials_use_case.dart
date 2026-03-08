import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';
import 'package:ev_products_app/feature/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para autenticacion con email y password.
class LoginCredentialsUseCase {
  final AuthRepository _authRepository;

  LoginCredentialsUseCase(this._authRepository);

  Future<UserApp> call(String email, String password) async {
    return _authRepository.loginWithCredentials(email, password);
  }
}
