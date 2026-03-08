import 'package:ev_products_app/core/environment/environments.dart';
import 'package:ev_products_app/core/storage/secure_storage_service.dart';
import 'package:ev_products_app/feature/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// Implementacion remota de autenticacion sobre Firebase Auth.
///
/// Ademas del login, persiste el idToken en almacenamiento seguro para
/// permitir restaurar sesion en arranques posteriores.
class AuthFirebaseDatasourceImpl extends AuthFirebaseDatasource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  final SecureStorageService secureStorage;

  AuthFirebaseDatasourceImpl(this.secureStorage);

  @override
  Future<UserApp> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        await secureStorage.write("token", token);
      }
      return UserApp(
        id: userCredential.user?.uid ?? "",
        email: userCredential.user?.email ?? "",
        name: userCredential.user?.displayName ?? "",
      );
    } catch (e) {
      throw Exception('Error signing in with email and password: $e');
    }
  }

  @override
  Future<UserApp> signInWithGoogle() async {
    try {
      // Se inicializa con server client id para flujo compatible con backend.
      await _googleSignIn.initialize(
        serverClientId: Environments.firebaseClientId,
      );
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final token = await userCredential.user?.getIdToken();

      if (token != null) {
        await secureStorage.write("token", token);
      }

      return UserApp(
        id: userCredential.user?.uid ?? "",
        email: userCredential.user?.email ?? "",
        name: userCredential.user?.displayName ?? "",
      );
    } on GoogleSignInException catch (_) {
      throw Exception('Error signing with google, check your internet conection');
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  @override
  Future<UserApp> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login(
        permissions: ["email", "public_profile"],
      );

      if (result.status == LoginStatus.cancelled) {
        throw Exception('Facebook login cancelled by user');
      }

      if (result.status != LoginStatus.success || result.accessToken == null) {
        throw Exception('Facebook login failed: ${result.status} ${result.message ?? ''}');
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        await secureStorage.write("token", token);
      }

      return UserApp(
        id: userCredential.user?.uid ?? "",
        email: userCredential.user?.email ?? "",
        name: userCredential.user?.displayName ?? "",
      );
    } on FirebaseAuthException catch (_) {
      throw Exception(
        'Error signing in with Facebook, check your internet connection and make sure you have the Facebook app installed',
      );
    } catch (e) {
      throw Exception('Error signing in with Facebook: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await secureStorage.delete("token");
    } catch (e) {
      throw Exception('Error signout $e');
    }
  }

  @override
  Future<UserApp?> checkLogin() async {
    try {
      final token = await secureStorage.read("token");
      // Se valida consistencia entre token persistido y usuario actual.
      if (token != null) {
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          final idTokenResult = await user.getIdTokenResult();
          if (idTokenResult.token == token) {
            return UserApp(
              id: user.uid,
              email: user.email ?? "",
              name: user.displayName ?? "",
            );
          } else {
            // Si el token no coincide, se limpia para evitar sesion corrupta.
            await secureStorage.delete("token");
            return null;
          }
        } else {
          // Si no hay usuario autenticado, el token cacheado se invalida.
          await secureStorage.delete("token");
          return null;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error checking login status: $e');
    }
  }

  @override
  Future<UserApp> registerWithEmailAndPassword(
    String fullName,
    String email,
    String password,
  ) {
    try {
      return _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
            final user = userCredential.user;
            if (user != null) {
              await user.updateDisplayName(fullName);
              final token = await user.getIdToken();
              if (token != null) {
                await secureStorage.write("token", token);
              }
              return UserApp(
                id: user.uid,
                email: user.email ?? "",
                name: user.displayName ?? "",
              );
            } else {
              throw Exception('User registration failed');
            }
          });
    } catch (e) {
      throw Exception('Error registering with email and password: $e');
    }
  }
}
