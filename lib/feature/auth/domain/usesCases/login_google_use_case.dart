import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';
import 'package:ev_products_app/feature/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para autenticacion via Google.
class LoginGoogleUseCase {
  final AuthRepository _authRepository;

  LoginGoogleUseCase(this._authRepository);

  Future<UserApp> call() async {
    return _authRepository.loginGoogle();
  }
}
