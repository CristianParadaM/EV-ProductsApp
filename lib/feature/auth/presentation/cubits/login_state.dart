import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.registered({required UserApp user}) = _Registered;
  const factory LoginState.authenticated({required UserApp user}) =
      _Authenticated;
  const factory LoginState.unauthenticated() = _Unauthenticated;
  const factory LoginState.failure({required String error}) = _Failure;
}
