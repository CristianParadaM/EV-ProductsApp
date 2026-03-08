import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';
import 'package:ev_products_app/feature/layout/domain/repositories/page_item_repository.dart';
import 'package:ev_products_app/feature/layout/domain/uses_cases/get_items_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePageItemRepository implements PageItemRepository {
  _FakePageItemRepository(this._items);

  final List<PageItem> _items;
  int calls = 0;

  @override
  Future<List<PageItem>> getPageItems() async {
    calls++;
    return _items;
  }
}

void main() {
  test('GetItemsTabsUseCase retorna items desde el repositorio', () async {
    final expected = [
      PageItem(index: 0, name: 'productos', path: '/products', icon: Icons.home),
      PageItem(index: 1, name: 'ajustes', path: '/settings', icon: Icons.settings),
    ];

    final repository = _FakePageItemRepository(expected);
    final useCase = GetItemsTabsUseCase(repository: repository);

    final result = await useCase();

    expect(result, expected);
    expect(repository.calls, 1);
  });
}
