import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';
import 'package:ev_products_app/feature/auth/domain/repositories/auth_repository.dart';

class RegisterWithCredentialsUseCase {
  final AuthRepository _authRepository;

  RegisterWithCredentialsUseCase(this._authRepository);

  Future<UserApp> call(String fullName, String email, String password) async {
    return _authRepository.registerWithCredentials(fullName, email, password);
  }
}
