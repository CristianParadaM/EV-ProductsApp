import 'package:ev_products_app/core/l10n/app_localizations.dart';
import 'package:ev_products_app/feature/products/presentation/screens/cart/cart_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CartPage muestra textos clave', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: CartPage(),
      ),
    );

    final context = tester.element(find.byType(CartPage));
    final l10n = AppLocalizations.of(context);

    expect(find.text(l10n.cartTitle), findsOneWidget);
    expect(find.text(l10n.screenInConstruction), findsOneWidget);
    expect(find.text(l10n.screenInConstructionMessage), findsOneWidget);
  });
}
