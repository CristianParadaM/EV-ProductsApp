import 'package:ev_products_app/core/di/injector_container.dart';
import 'package:ev_products_app/core/splash/splash.dart';
import 'package:ev_products_app/feature/auth/presentation/screens/login/login_page.dart';
import 'package:ev_products_app/feature/auth/presentation/screens/register/register_page.dart';
import 'package:ev_products_app/feature/auth/presentation/screens/start_page.dart';
import 'package:ev_products_app/feature/layout/presentation/cubits/layout_cubit.dart';
import 'package:ev_products_app/feature/layout/presentation/screens/layout.dart';
import 'package:ev_products_app/feature/products/presentation/cubits/products_cubit.dart';
import 'package:ev_products_app/feature/products/presentation/screens/cart/cart_screen.dart';
import 'package:ev_products_app/feature/products/presentation/screens/detail/detail_screen.dart';
import 'package:ev_products_app/feature/products/presentation/screens/products/products_screen.dart';
import 'package:ev_products_app/feature/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Definicion del router principal de la app.
///
/// Las rutas publicas (splash/start/auth) viven al nivel superior.
/// La navegacion autenticada se agrupa en un `ShellRoute` para compartir el
/// mismo scaffold de navegacion inferior.
final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
    ),

    GoRoute(
      path: '/start',
      name: 'start',
      builder: (context, state) {
        return StartPage();
      },
    ),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) {
        return RegisterPage();
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          // El estado del layout se comparte entre todas las tabs del shell.
          create: (_) => InjectorContainer.instance<LayoutCubit>()..load(),
          child: MyNavigationBar(child: child),
        );
      },
      routes: [
        GoRoute(
          path: '/products',
          name: 'products',
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider(
              // La lista de productos maneja su cubit por instancia de ruta.
              create: (_) =>
                  InjectorContainer.instance<ProductsCubit>()..load(limit: 10, offset: 1),
              child: ProductsPage(),
            ),
          ),
        ),

        GoRoute(
          path: '/product/:productId',
          name: 'detail',
          pageBuilder: (context, state) {
            final productId = int.tryParse(
              state.pathParameters['productId'] ?? '',
            );

            return NoTransitionPage(
              child: BlocProvider(
                // Detail puede ejecutar operaciones de productos de forma aislada.
                create: (_) => InjectorContainer.instance<ProductsCubit>(),
                // Si el path param es invalido cae a 0; la pantalla lo maneja.
                child: DetailPage(productId: productId ?? 0),
              ),
            );
          },
        ),
        
        GoRoute(
          path: '/cart',
          name: 'cart',
          pageBuilder: (context, state) => NoTransitionPage(
            child: CartPage(),
          ),
        ),

        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: SettingsPage()),
        ),
      ],
    ),
  ],
);
