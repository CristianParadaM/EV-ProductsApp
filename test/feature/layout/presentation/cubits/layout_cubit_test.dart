import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';
import 'package:ev_products_app/feature/layout/domain/repositories/page_item_repository.dart';
import 'package:ev_products_app/feature/layout/domain/uses_cases/get_items_tabs.dart';
import 'package:ev_products_app/feature/layout/presentation/cubits/layout_cubit.dart';
import 'package:ev_products_app/feature/layout/presentation/cubits/layout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _SuccessRepository implements PageItemRepository {
  _SuccessRepository(this.items);

  final List<PageItem> items;

  @override
  Future<List<PageItem>> getPageItems() async => items;
}

class _FailureRepository implements PageItemRepository {
  @override
  Future<List<PageItem>> getPageItems() async {
    throw Exception('fallo forzado');
  }
}

void main() {
  group('LayoutCubit', () {
    test('emite loading y loaded cuando la carga es exitosa', () async {
      final expectedItems = [
        PageItem(index: 0, name: 'carrito', path: '/cart', icon: Icons.shopping_cart),
      ];
      final cubit = LayoutCubit(
        GetItemsTabsUseCase(repository: _SuccessRepository(expectedItems)),
      );

      expectLater(
        cubit.stream,
        emitsInOrder([
          const LayoutState.loading(),
          LayoutState.loaded(items: expectedItems),
        ]),
      );

      await cubit.load();
      await cubit.close();
    });

    test('emite loading y error cuando ocurre una excepcion', () async {
      final cubit = LayoutCubit(
        GetItemsTabsUseCase(repository: _FailureRepository()),
      );

      expectLater(
        cubit.stream,
        emitsInOrder([
          const LayoutState.loading(),
          isA<LayoutState>().having(
            (state) => state.maybeWhen(
              error: (message) => message,
              orElse: () => '',
            ),
            'mensaje de error',
            contains('fallo forzado'),
          ),
        ]),
      );

      await cubit.load();
      await cubit.close();
    });
  });
}
