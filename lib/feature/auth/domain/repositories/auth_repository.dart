
import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserApp> loginWithCredentials(String email, String password);
  Future<UserApp> loginGoogle();
  Future<UserApp> loginFacebook();
  Future<void> logout();
  Future<UserApp?> checkLogin();
  Future<UserApp> registerWithCredentials(
    String fullName,
    String email,
    String password,
  );
}
