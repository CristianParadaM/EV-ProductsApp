import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:ev_products_app/core/l10n/app_localizations.dart';
import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';
import 'package:ev_products_app/feature/layout/presentation/cubits/layout_cubit.dart';
import 'package:ev_products_app/feature/layout/presentation/cubits/layout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyNavigationBar extends StatelessWidget {
  final Widget child;

  const MyNavigationBar({super.key, required this.child});

  int _calculateIndex(BuildContext context, List<PageItem> pageItems) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = pageItems.indexWhere(
      (item) => location == item.path || location.startsWith('${item.path}/'),
    );
    return selectedIndex >= 0 ? selectedIndex : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildNavigationBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return state.when(
          initial: () => SizedBox.shrink(),
          loading: () => Center(child: CircularProgressIndicator()),
          loaded: (data) => _buildCurvedNavigationBar(data, context),
          error: (error) => Text('${l10n.errorPrefix}: $error'),
        );
      },
    );
  }

  Widget _buildCurvedNavigationBar(
    List<PageItem> pageItems,
    BuildContext context,
  ) {
    final index = _calculateIndex(context, pageItems);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final iconTheme = theme.navigationBarTheme.iconTheme;

    final colorIconSelected =
        iconTheme?.resolve({WidgetState.selected})?.color ?? Colors.white;
    final colorIconUnselected =
        iconTheme?.resolve({})?.color ??
        (theme.brightness == Brightness.dark
            ? const Color(0xFFBDBDBD)
            : Colors.black);

    return Column(
      children: [
        CurvedNavigationBar(
          index: index,
          onTap: (newIndex) {
            if (newIndex < 0 || newIndex >= pageItems.length) return;
            context.goNamed(pageItems[newIndex].name);
          },
          animationDuration: const Duration(milliseconds: 200),
          items: List.generate(pageItems.length, (itemIndex) {
            final item = pageItems[itemIndex];
            return CurvedNavigationBarItem(
              child: Icon(
                item.icon,
                color: index == itemIndex
                    ? colorIconSelected
                    : colorIconUnselected,
              ),
              label: l10n.navLabel(item.name),
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
          buttonBackgroundColor: theme.primaryColor,
          backgroundColor: Colors.transparent,
          color:
              theme.navigationBarTheme.backgroundColor ?? theme.primaryColor,
          iconPadding: 18,
        ),
        Container(
          width: double.infinity,
          height: 20,
          color: theme.navigationBarTheme.backgroundColor ?? theme.primaryColor,
        ),
      ],
    );
  }
}
