import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'products_state.freezed.dart';

@freezed
class ProductsState with _$ProductsState {
  /// Estado inicial
  const factory ProductsState.initial() = _Initial;

  /// Estado de carga
  const factory ProductsState.loading() = _Loading;

  /// Estado de éxito
  const factory ProductsState.loaded({
    required List<Product> featuredProducts,
    required List<Product> products,
    required List<Category> categories,
  }) = _Loaded;

  const factory ProductsState.detailLoaded({
    required Product product,
  }) = _DetailLoaded;

  /// Estado de error
  const factory ProductsState.error({
    required String message,
  }) = _Error;
}
