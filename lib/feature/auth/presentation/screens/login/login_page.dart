import 'package:ev_products_app/core/environment/environments.dart';
import 'package:ev_products_app/core/l10n/app_localizations.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_cubit.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, LoginState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          authenticated: (user) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Login exitoso")));
            context.goNamed("products");
          },
          failure: (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error: $error")));
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final colorScheme = theme.colorScheme;

        return Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primaryContainer.withValues(alpha: 1.0),
                  theme.canvasColor,
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  _buildLoginForm(theme, isLoading, context),
                  if (isLoading)
                    ColoredBox(
                      color: theme.colorScheme.scrim.withValues(alpha: 0.2),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm(
    ThemeData theme,
    bool isLoading,
    BuildContext context,
  ) {
    final l10 = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10.loginTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10.loginSubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(  
                ImagePaths.loginGif,
                height: 200,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: l10.emailLabel,
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) {
                    return l10.requiredValue;
                  }
                  final isValidEmail = RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  ).hasMatch(email);
                  if (!isValidEmail) {
                    return l10.invalidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: l10.passwordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  final password = value ?? '';
                  if (password.isEmpty) {
                    return l10.requiredValue;
                  }
                  return null;
                },
              ),
              // Forgot password? (opcional)
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Acción para recuperar contraseña
                  },
                  child: Text(l10.forgotPassword),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: isLoading ? null : () => _onSubmit(context),
                child: Text(l10.loginButton),
              ),
              TextButton(
                onPressed: () {
                  context.goNamed("register");
                },
                child: Text(l10.createNewAccount),
              ),
              const SizedBox(height: 20),
              Text(
                l10.orLoginWith,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => _loginFacebook(context),
                      icon: const Icon(Icons.facebook_rounded),
                      label: const Text("Facebook"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : () => _loginGoogle(context),
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text("Google"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context
        .read<AuthCubit>()
        .loginWithCredentials(
          emailController.text.trim(),
          passwordController.text,
        )
        .catchError((e) {
          debugPrint("Error en el login: ${e.toString()}");
        });
  }

  void _loginFacebook(BuildContext context) {
    context.read<AuthCubit>().loginWithFacebook().catchError((e) {
      debugPrint("Error en el login con facebook: ${e.toString()}");
    });
  }

  void _loginGoogle(BuildContext context) {
    context.read<AuthCubit>().loginWithGoogle().catchError((e) {
      debugPrint("Error en el login con google: ${e.toString()}");
    });
  }
}
