import 'package:ev_products_app/core/environment/environments.dart';
import 'package:ev_products_app/core/l10n/app_localizations.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_cubit.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController fullName;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, LoginState>(
      listener: (context, state) {
        final l10 = AppLocalizations.of(context);

        state.maybeWhen(
          orElse: () {},
          authenticated: (user) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Login exitoso")));
            context.goNamed("products");
          },
          registered: (user) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "${user.name.split(' ')[0]}! ${l10.notificationRegisterSuccess}",
                ),
              ),
            );
            context.goNamed("login");
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
                  _buildRegisterForm(theme, isLoading, context),
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

  Center _buildRegisterForm(
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
                l10.registerTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10.registerSubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(ImagePaths.registerGif, height: 120),
              const SizedBox(height: 20),
              TextFormField(
                controller: fullName,
                keyboardType: TextInputType.text,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: l10.nameLabel,
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  final name = value?.trim() ?? '';
                  if (name.isEmpty) {
                    return l10.requiredValue;
                  }
                  return null;
                },
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
                  final isValidPassword = RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                  ).hasMatch(password);
                  if (!isValidPassword) {
                    return l10.invalidPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordConfirmController,
                obscureText: _obscurePassword,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: l10.confirmPasswordLabel,
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
                  if (password != passwordController.text) {
                    return l10.passwordMismatch;
                  }
                  // Expresion regular minimo 8 caracteres, al menos una letra mayúscula, una letra minúscula, un número y un caracter especial
                  final isValidPassword = RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                  ).hasMatch(password);
                  if (!isValidPassword) {
                    return l10.invalidPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: isLoading ? null : () => _onSubmit(context),
                child: Text(l10.buttonStartRegister),
              ),
              TextButton(
                onPressed: () {
                  context.goNamed("login");
                },
                child: Text(l10.alreadyHaveAccount),
              ),
              const SizedBox(height: 40),
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
    fullName = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    fullName.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context
        .read<AuthCubit>()
        .registerWithCredentials(
          fullName.text.trim(),
          emailController.text.trim(),
          passwordController.text,
        )
        .catchError((e) {
          debugPrint("Error en el registro: ${e.toString()}");
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
