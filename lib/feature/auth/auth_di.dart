import 'package:get_it/get_it.dart';
import 'package:ev_products_app/core/di/injector_container.dart';
import 'package:ev_products_app/feature/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:ev_products_app/feature/auth/data/datasources/auth_firebase_datasource_impl.dart';
import 'package:ev_products_app/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:ev_products_app/feature/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:ev_products_app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:ev_products_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/check_login.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/login_credentials_use_case.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/login_facebook_use_case.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/login_google_use_case.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/logout_use_case.dart';
import 'package:ev_products_app/feature/auth/domain/usesCases/register_with_credentials_use_case.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_cubit.dart';

void initAuthFeature() {
  final GetIt instance = InjectorContainer.instance;

  instance.registerFactory(
    () => AuthCubit(
      instance(),
      instance(),
      instance(),
      instance(),
      instance(),
      instance(),
    ),
  );

  instance.registerLazySingleton(() => LoginCredentialsUseCase(instance()));
  instance.registerLazySingleton(() => LoginGoogleUseCase(instance()));
  instance.registerLazySingleton(() => LoginFacebookUseCase(instance()));
  instance.registerLazySingleton(() => LogoutUseCase(instance()));
  instance.registerLazySingleton(() => CheckLoginUseCase(instance()));
  instance.registerLazySingleton(
    () => RegisterWithCredentialsUseCase(instance()),
  );

  instance.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      instance<AuthFirebaseDatasource>(),
      instance<AuthLocalDatasource>(),
    ),
  );

  instance.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(instance()),
  );

  instance.registerLazySingleton<AuthFirebaseDatasource>(
    () => AuthFirebaseDatasourceImpl(instance()),
  );
}
