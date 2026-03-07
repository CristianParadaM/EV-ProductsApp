
import 'package:ev_products_app/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';

class UserLoginDTO {
  final String id;
  final String email;
  final String password;
  final String name;

  UserLoginDTO({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  final List<UserLoginDTO> _users = [
    UserLoginDTO(
      id: "1",
      email: "admin@app.com",
      password: "admin123",
      name: "Admin",
    ),
  ];

  @override
  Future<UserApp> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final user = _users.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Usuario no encontrado'),
      );
      return UserApp(id: user.id, email: user.email, name: user.name);
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }
}
