import 'package:ev_products_app/feature/settings/domain/entities/settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@Freezed()
class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = _Initial;
  const factory SettingsState.loading() = _Loading;
  const factory SettingsState.loaded({required Settings settings}) = _Loaded;
  const factory SettingsState.error({required String message}) = _Error;
}
