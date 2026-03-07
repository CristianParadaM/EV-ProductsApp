import 'package:ev_products_app/core/environment/environments.dart';
import 'package:ev_products_app/core/l10n/app_localizations.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_cubit.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10 = AppLocalizations.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<AuthCubit, LoginState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          authenticated: (user) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10.notificationLoginSuccess)));
            context.goNamed("products");
          },
          failure: (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primaryContainer.withValues(alpha: 0.35),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(ImagePaths.startImage),
                      Text(
                        l10.appStartTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10.appStartSubTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 100),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => context.goNamed('login'),
                              child: Text(l10.buttonStartLogin),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => context.goNamed('register'),
                              child: Text(l10.buttonStartRegister),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
