import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

class NozulDrawer extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback onLoginPressed;

  const NozulDrawer({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.onLoginPressed,
  });

  Future<void> _chooseCurrency(BuildContext context) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.darkGold;
    final surfaceColor = isDark
        ? AppColors.DarkSurface
        : AppColors.lightSurface;

    final currency = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('اختر العملة'),
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        children: [
          for (final option in [
            'ريال يمني جديد',
            'ريال يمني قديم',
            'ريال سعودي',
            'دولار أمريكي',
          ])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, option),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(option)),
                    Icon(
                      option == selectedCurrency
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: goldColor,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
    if (!context.mounted || currency == null) return;
    onCurrencyChanged(currency);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.darkGold;
    final surfaceColor = isDark
        ? AppColors.DarkSurface
        : AppColors.lightSurface;

    return Drawer(
      backgroundColor: surfaceColor,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: goldColor.withAlpha(30),
                      child: Icon(
                        Icons.person_outline,
                        size: 48,
                        color: goldColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'زائر',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'تتصفح دون تسجيل الدخول',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      TextButton(
                        onPressed: onLoginPressed,
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: goldColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.settings_outlined, color: goldColor),
                    title: const Text('الإعدادات'),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.currency_exchange, color: goldColor),
                    title: const Text('اختيار العملة'),
                    subtitle: Text(selectedCurrency),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () => _chooseCurrency(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      isDark
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      color: goldColor,
                    ),
                    title: const Text('المظهر'),
                    trailing: Semantics(
                      label: 'الوضع الداكن',
                      toggled: isDark,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () async {
                          final isLight =
                              AppTheme.appThemeMode.value != ThemeMode.light;

                          AppTheme.appThemeMode.value = isLight
                              ? ThemeMode.light
                              : ThemeMode.dark;

                          await SharedPreferencesAsync().setBool(
                            'is_light_mode',
                            isLight,
                          );
                        },

                        child: Container(
                          width: 75,
                          height: 30,
                          padding: const EdgeInsets.all(3.5),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                alignment: isDark
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: goldColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                              ),
                              Row(
                                textDirection: TextDirection.ltr,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2.5),
                                      child: Icon(
                                        Icons.light_mode_outlined,
                                        size: 16,
                                        color: !isDark
                                            ? AppColors.lightText
                                            : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.dark_mode_outlined,
                                        size: 18,
                                        color: isDark
                                            ? AppColors.darkText
                                            : theme.colorScheme.onSurface,
                                      ),
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
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.support_agent, color: goldColor),
                    title: const Text('تواصل معنا'),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: goldColor),
                    title: const Text('عن التطبيق'),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
