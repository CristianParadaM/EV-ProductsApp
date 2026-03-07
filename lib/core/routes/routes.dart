import 'package:ev_products_app/core/splash/splash.dart';
import 'package:ev_products_app/feature/auth/presentation/screens/login/login_page.dart';
import 'package:ev_products_app/feature/auth/presentation/screens/register/register_page.dart';
import 'package:ev_products_app/feature/auth/presentation/screens/start_page.dart';
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
  ],
);
