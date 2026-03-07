import 'package:ev_products_app/core/di/injector_container.dart';
import 'package:ev_products_app/core/splash/splash.dart';
import 'package:ev_products_app/feature/auth/presentation/screens/login/login_page.dart';
import 'package:ev_products_app/feature/auth/presentation/screens/register/register_page.dart';
import 'package:ev_products_app/feature/auth/presentation/screens/start_page.dart';
import 'package:ev_products_app/feature/layout/presentation/cubits/layout_cubit.dart';
import 'package:ev_products_app/feature/layout/presentation/screens/layout.dart';
import 'package:ev_products_app/feature/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
          create: (_) => InjectorContainer.instance<LayoutCubit>()..load(),
          child: MyNavigationBar(child: child),
        );
      },
      routes: [
        GoRoute(
          path: '/products',
          name: 'products',
          pageBuilder: (context, state) => NoTransitionPage(
            child: Center(child: Text('Products Page')),
          ),
        ),

        
        GoRoute(
          path: '/cart',
          name: 'cart',
          pageBuilder: (context, state) => NoTransitionPage(
            child: Center(child: Text('Cart Page')),
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
