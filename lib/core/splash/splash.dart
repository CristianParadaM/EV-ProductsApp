import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ev_products_app/core/environment/environments.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
        await Future.delayed(const Duration(seconds: 3));
        if (context.mounted) {
          context.goNamed("start");
        }
        return const SizedBox.shrink();
      },
    );
  }
}
