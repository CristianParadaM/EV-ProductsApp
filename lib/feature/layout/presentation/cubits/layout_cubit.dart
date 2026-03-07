import 'package:ev_products_app/feature/layout/domain/uses_cases/get_items_tabs.dart';
import 'package:ev_products_app/feature/layout/presentation/cubits/layout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutCubit extends Cubit<LayoutState> {
  GetItemsTabsUseCase getItemsTabsUseCase;

  LayoutCubit(this.getItemsTabsUseCase) : super(const LayoutState.initial());

  Future<void> load() async {
    emit(const LayoutState.loading());
    try {
      final items = await getItemsTabsUseCase();
      emit(LayoutState.loaded(items: items));
    } catch (e) {
      emit(LayoutState.error(message: e.toString()));
    }
  }
}
