
import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';

/// Contrato del origen remoto de autenticacion.
///
/// Define operaciones soportadas por proveedores externos (Firebase/OAuth).
abstract class AuthFirebaseDatasource {
  Future<UserApp> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<UserApp> signInWithGoogle();
  Future<UserApp> signInWithFacebook();
  Future<void> signOut();
  Future<UserApp?> checkLogin();
  Future<UserApp> registerWithEmailAndPassword(
    String fullName,
    String email,
    String password,
  );
}
