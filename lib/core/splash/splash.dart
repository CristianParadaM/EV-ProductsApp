import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ev_products_app/core/environment/environments.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

/// Splash inicial que reproduce animacion y hace la transicion temporizada.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      centered: true,
      duration: 2000,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 800,
      splash: Lottie.asset(ImagePaths.splashAnimation, repeat: true),

      screenFunction: () async {
        // Mantiene el splash visible para branding y estabilizar cold start.
        await Future.delayed(const Duration(seconds: 3));
        if (context.mounted) {
          context.goNamed("start");
        }
        // Requerido por la API; el efecto real es la navegacion.
        return const SizedBox.shrink();
      },
    );
  }
}
