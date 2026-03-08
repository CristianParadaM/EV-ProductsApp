
import 'package:ev_products_app/feature/auth/data/models/user_model.dart';
import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';

abstract class AuthLocalDatasource {
  Future<UserApp> loginWithEmailAndPassword(String email, String password);
  Future<void> saveUser(UserModel user);
}
