import 'package:ev_products_app/core/di/injector_container.dart';
import 'package:ev_products_app/feature/products/data/datasources/product_datasource.dart';
import 'package:ev_products_app/feature/products/data/datasources/product_datasource_api.dart';
import 'package:ev_products_app/feature/products/data/repositories/product_repository_impl.dart';
import 'package:ev_products_app/feature/products/domain/repositories/products_repository.dart';
import 'package:ev_products_app/feature/products/domain/uses_cases/get_categories.dart';
import 'package:ev_products_app/feature/products/domain/uses_cases/get_detailProduct.dart';
import 'package:ev_products_app/feature/products/domain/uses_cases/get_featured_products.dart';
import 'package:ev_products_app/feature/products/domain/uses_cases/get_products.dart';
import 'package:ev_products_app/feature/products/domain/uses_cases/get_products_by_category.dart';
import 'package:ev_products_app/feature/products/presentation/cubits/products_cubit.dart';
import 'package:get_it/get_it.dart';

void initProductsFeature() {
  final GetIt instance = InjectorContainer.instance;
  // cubits
  instance.registerFactory(
    () => ProductsCubit(
      instance(),
      instance(),
      instance(),
      instance(),
      instance(),
    ),
  );
  // casos de uso
  instance.registerLazySingleton(
    () => GetProducts(productsRepository: instance()),
  );
  instance.registerLazySingleton(
    () => GetFeaturedProducts(productsRepository: instance()),
  );
  instance.registerLazySingleton(
    () => GetProductsByCategory(productsRepository: instance()),
  );
  instance.registerLazySingleton(
    () => GetCategories(productsRepository: instance()),
  );
  instance.registerLazySingleton(
    () => GetProductDetail(productsRepository: instance()),
  );
  // repos
  instance.registerLazySingleton<ProductsRepository>(
    () => ProductRepositoryImpl(
      remoteDatasource: instance<ProductDatasource>(),
    ),
  );
  // datasources
  instance.registerLazySingleton<ProductDatasource>(
    () => ProductDatasourceAPI(instance()),
  );
}
