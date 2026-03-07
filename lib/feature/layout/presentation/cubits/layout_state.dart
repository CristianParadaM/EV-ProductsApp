import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'layout_state.freezed.dart';

@freezed
class LayoutState with _$LayoutState {
  const factory LayoutState.initial() = _Initial;
  const factory LayoutState.loading() = _Loading;
  const factory LayoutState.loaded({required List<PageItem> items}) = _Loaded;
  const factory LayoutState.error({required String message}) = _Error;
}
