

import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';
import 'package:ev_products_app/feature/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para consultar sesion vigente.
class CheckLoginUseCase {
  final AuthRepository _authRepository;

  CheckLoginUseCase(this._authRepository);

  Future<UserApp?> call() async {
    return _authRepository.checkLogin();
  }
}
