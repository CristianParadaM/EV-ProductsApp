import 'package:ev_products_app/core/di/injector_container.dart';
import 'package:ev_products_app/feature/layout/data/datasources/abs_layout_datasource.dart';
import 'package:ev_products_app/feature/layout/data/datasources/layout_datasource_local.dart';
import 'package:ev_products_app/feature/layout/data/repositories/layout_repository_imp.dart';
import 'package:ev_products_app/feature/layout/domain/repositories/page_item_repository.dart';
import 'package:ev_products_app/feature/layout/domain/uses_cases/get_items_tabs.dart';
import 'package:ev_products_app/feature/layout/presentation/cubits/layout_cubit.dart';
import 'package:get_it/get_it.dart';

void initLayoutFeature() {
  final GetIt instance = InjectorContainer.instance;
  // Cubits
  instance.registerFactory(() => LayoutCubit(instance()));

  // Use Cases
  instance.registerLazySingleton(
    () => GetItemsTabsUseCase(repository: instance()),
  );
  // Repository
  instance.registerLazySingleton<PageItemRepository>(
    () => LayoutRepositoryImp(datasource: instance()),
  );
  // Datasource
  instance.registerLazySingleton<AbsLayoutDatasource>(
    () => LayoutDatasourceLocal(),
  );


}
