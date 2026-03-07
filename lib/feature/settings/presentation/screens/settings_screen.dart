import 'package:ev_products_app/core/environment/environments.dart';
import 'package:ev_products_app/core/l10n/app_localizations.dart';
import 'package:ev_products_app/feature/auth/domain/entities/user_entity.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_cubit.dart';
import 'package:ev_products_app/feature/auth/presentation/cubits/login_state.dart';
import 'package:ev_products_app/feature/settings/presentation/cubits/settings_cubit.dart';
import 'package:ev_products_app/feature/settings/presentation/cubits/settings_state.dart';
import 'package:ev_products_app/feature/snack_bar/snack_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  UserApp? _resolveUser(LoginState state) {
    return state.maybeWhen(
      authenticated: (user) => user,
      registered: (user) => user,
      orElse: () => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) =>
                Center(child: Text('${l10n.errorPrefix}: $message')),
            loaded: (settings) {
              final isDark = settings.themeMode == ThemeMode.dark;

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primaryContainer.withValues(alpha: 1.0),
                      theme.canvasColor,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        l10n.settingsTitle,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.settingsSubtitle,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      _SettingsCard(
                        child: BlocBuilder<AuthCubit, LoginState>(
                          builder: (context, authState) {
                            final user = _resolveUser(authState);
                            return Row(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor: theme.colorScheme.primary
                                      .withValues(alpha: 0.12),
                                  child: Icon(
                                    Icons.person,
                                    size: 34,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        l10n.settingsAccountSection,
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        (user?.name.isNotEmpty ?? false)
                                            ? user!.name
                                            : l10n.settingsUnknownUser,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        (user?.email.isNotEmpty ?? false)
                                            ? user!.email
                                            : l10n.settingsUnknownEmail,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SettingsCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.settingsThemeSection,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SegmentedButton<ThemeMode>(
                              segments: [
                                ButtonSegment<ThemeMode>(
                                  value: ThemeMode.light,
                                  icon: const Icon(Icons.light_mode_outlined),
                                  label: Text(l10n.settingsThemeLight),
                                ),
                                ButtonSegment<ThemeMode>(
                                  value: ThemeMode.dark,
                                  icon: const Icon(Icons.dark_mode_outlined),
                                  label: Text(l10n.settingsThemeDark),
                                ),
                              ],
                              selected: {
                                isDark ? ThemeMode.dark : ThemeMode.light,
                              },
                              onSelectionChanged: (selection) {
                                final selectedTheme = selection.first;
                                context.read<SettingsCubit>().changeTheme(
                                  selectedTheme,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SettingsCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.settingsLanguageSection,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SegmentedButton<String>(
                              segments: [
                                ButtonSegment<String>(
                                  value: 'es',
                                  label: Text(l10n.settingsLanguageEs),
                                ),
                                ButtonSegment<String>(
                                  value: 'en',
                                  label: Text(l10n.settingsLanguageEn),
                                ),
                              ],
                              selected: {settings.language.toLowerCase()},
                              onSelectionChanged: (selection) {
                                context.read<SettingsCubit>().changeLanguage(
                                  selection.first,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      FilledButton(
                        onPressed: () => _logout(context, l10n),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(l10n.settingsLogoutButton),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Text(
                          '${l10n.settingsVersionLabel} ${Environments.versionApp}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context, AppLocalizations l10n) async {
    await context.read<AuthCubit>().logout();
    if (!context.mounted) return;
    SnackbarCustom(context).showSuccess(l10n.notificationLogoutSuccess);
    context.goNamed('login');
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
