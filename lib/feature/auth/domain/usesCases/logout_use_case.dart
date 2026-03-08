import 'package:ev_products_app/feature/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para cierre de sesion.
class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<void> call() async {
    return _authRepository.logout();
  }
}