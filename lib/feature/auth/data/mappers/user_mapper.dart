
import 'package:ev_products_app/feature/auth/data/models/user_model.dart';
import 'package:ev_products_app/feature/auth/data/security/password_hasher.dart';
import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';

class UserMapper {
  UserMapper._();

  static UserApp modelToDomain(Map<String, dynamic> json) {
    return UserApp(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  static UserModel domainToModel(UserApp user, String password) {
    final cipherPassword = PasswordHasher.hashPassword(password);
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      password: cipherPassword,
    );
  }
}