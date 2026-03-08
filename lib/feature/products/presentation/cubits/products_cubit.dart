import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/entities/product.dart';
import 'package:ev_products_app/feature/products/domain/uses_cases/get_categories.dart';
import 'package:ev_products_app/feature/products/domain/uses_cases/get_detailProduct.dart';
import 'package:ev_products_app/feature/products/domain/uses_cases/get_featured_products.dart';
import 'package:ev_products_app/feature/products/domain/uses_cases/get_products.dart';
import 'package:ev_products_app/feature/products/domain/uses_cases/get_products_by_category.dart';
import 'package:ev_products_app/feature/products/presentation/cubits/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProducts getProducts;
  final GetCategories getCategories;
  final GetProductsByCategory getProductsByCategory;
  final GetFeaturedProducts getFeaturedProducts;
  final GetProductDetail getProductDetail;

  int _limit = 10;
  int _nextOffset = 1;
  bool _hasMoreProducts = true;
  bool _isLoadingMore = false;

  bool get hasMoreProducts => _hasMoreProducts;
  bool get isLoadingMore => _isLoadingMore;

  void _applyFeaturedDiscounts(
    List<Product> products,
    List<Product> featuredProducts,
  ) {
    final featuredById = {
      for (final featured in featuredProducts) featured.id: featured,
    };

    for (final product in products) {
      final featuredProduct = featuredById[product.id];
      if (featuredProduct == null) {
        continue;
      }

      if (featuredProduct.pricediscount != null) {
        product.pricediscount = featuredProduct.pricediscount;
      } else {
        product.applyRandomDiscount();
      }
    }
  }

  ProductsCubit(
    this.getProducts,
    this.getCategories,
    this.getProductsByCategory,
    this.getFeaturedProducts,
    this.getProductDetail,
  ) : super(ProductsState.initial());

  Future<void> load({int limit = 10, int offset = 1}) async {
    _limit = limit;
    _nextOffset = offset;
    _hasMoreProducts = true;
    _isLoadingMore = false;

    emit(ProductsState.loading());
    try {
      final results = await Future.wait([
        getFeaturedProducts(),
        getProducts(limit, offset),
        getCategories(),
      ]);
      final featuredProducts = results[0] as List<Product>;
      final products = results[1] as List<Product>;
      _nextOffset = offset + products.length;
      _hasMoreProducts = products.length == limit;
      _applyFeaturedDiscounts(products, featuredProducts);

      emit(
        ProductsState.loaded(
          featuredProducts: featuredProducts,
          products: products,
          categories: results[2] as List<Category>,
        ),
      );
    } catch (e) {
      print(e);
      emit(ProductsState.error(message: "Error al cargar los productos"));
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMoreProducts) {
      return;
    }

    final loadedData = state.maybeWhen(
      loaded: (featuredProducts, products, categories) => (
        featuredProducts: featuredProducts,
        products: products,
        categories: categories,
      ),
      orElse: () => null,
    );

    if (loadedData == null) {
      return;
    }

    _isLoadingMore = true;

    try {
      final newProducts = await getProducts(_limit, _nextOffset);

      if (newProducts.isEmpty) {
        _hasMoreProducts = false;
        return;
      }

      _applyFeaturedDiscounts(newProducts, loadedData.featuredProducts);

      final mergedProducts = [...loadedData.products, ...newProducts];
      _nextOffset += newProducts.length;
      _hasMoreProducts = newProducts.length == _limit;

      emit(
        ProductsState.loaded(
          featuredProducts: loadedData.featuredProducts,
          products: mergedProducts,
          categories: loadedData.categories,
        ),
      );
    } catch (e) {
      print(e);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> detailProduct(int productId) async {

    final featuredProducts = state.maybeWhen(
      loaded: (featuredProducts, _, __) => featuredProducts,
      orElse: () => <Product>[],
    );

    emit(ProductsState.loading());

    try {
      final product = await getProductDetail(productId);

      Product? featuredProduct;
      for (final featured in featuredProducts) {
        if (featured.id == product.id) {
          featuredProduct = featured;
          break;
        }
      }

      if (featuredProduct != null) {
        product.pricediscount =
            featuredProduct.pricediscount ?? product.pricediscount;
      }

      emit(ProductsState.detailLoaded(product: product));
    } catch (e) {
      print(e);
      emit(
        ProductsState.error(message: "Error al cargar el detalle del producto"),
      );
    }
  }
}
