import 'package:ev_products_app/core/di/injector_container.dart';
import 'package:ev_products_app/core/l10n/app_localizations.dart';
import 'package:ev_products_app/core/network/connectivity_cubit.dart';
import 'package:ev_products_app/core/routes/routes.dart';
import 'package:ev_products_app/core/theme/app_theme.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_cubit.dart';
import 'package:ev_products_app/feature/settings/presentation/cubits/settings_cubit.dart';
import 'package:ev_products_app/feature/settings/presentation/cubits/settings_state.dart';
import 'package:ev_products_app/feature/shared/snack_bar/snack_bar_custom.dart';
import 'package:ev_products_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await InjectorContainer.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: InjectorContainer.instance<ConnectivityCubit>(),
        ),
        BlocProvider(
          create: (_) => InjectorContainer.instance<SettingsCubit>()..load(),
        ),
        BlocProvider(
          create: (_) => InjectorContainer.instance<AuthCubit>()..checkLogin(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<ScaffoldMessengerState> appMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hadConnectivityFailure = false;

  void _showOfflineSnackbar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    SnackbarCustom(context).hideSnackBar();
    SnackbarCustom(context).showOfflineSnackBar(
      l10n.offlineMessage,
      onRetry: () {
        context.read<ConnectivityCubit>().checkNow();
      },
      margin: EdgeInsets.only(bottom: 110, left: 20, right: 20),
    );
  }

  void _showOnlineSnackbar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    SnackbarCustom(context).hideSnackBar();
    SnackbarCustom(context).showInfo(
      l10n.onlineMessage,
      margin: EdgeInsets.only(bottom: 110, left: 20, right: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final themeMode = state.maybeWhen(
          loaded: (settings) => settings.themeMode,
          orElse: () => ThemeMode.system,
        );

        final locale = state.maybeWhen(
          loaded: (settings) {
            final languageCode = settings.language.toLowerCase();
            if (languageCode == 'es' || languageCode == 'en') {
              return Locale(languageCode);
            }
            return const Locale('es');
          },
          orElse: () => null,
        );

        return MaterialApp.router(
          title: 'EV Products App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: appRouter,
          builder: (context, child) {
            return BlocListener<ConnectivityCubit, ConnectivityStatus>(
              listener: (context, status) {
                if (status == ConnectivityStatus.offline) {
                  _hadConnectivityFailure = true;
                  _showOfflineSnackbar(context);
                } else {
                  if (_hadConnectivityFailure) {
                    _showOnlineSnackbar(context);
                    _hadConnectivityFailure = false;
                  }
                }
              },
              child: child ?? const SizedBox.shrink(),
            );
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
