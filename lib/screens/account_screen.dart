import 'package:flutter/material.dart';
// import 'package:nozul_app/theme/app_colors.dart';

import '../widgets/nozul_app_bar.dart';
import 'register_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    super.key,
    required this.account,
    required this.onMenuPressed,
  });

  final VoidCallback onMenuPressed;
  final RegistrationData account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: NozulAppBar(title: 'الملف الشخصي', onMenuPressed: onMenuPressed),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          112 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: colors.surface,
                  child: Icon(
                    Icons.person_outline,
                    size: 36,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.displayName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account.email,
                        style: TextStyle(color: colors.onPrimaryContainer),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.badge_outlined),
                  title: Text('البيانات الشخصية'),
                ),
                const Divider(height: 1),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('الاسم الأول'),
                        subtitle: Text(account.firstName),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('اسم العائلة'),
                        subtitle: Text(account.lastName),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('البريد الإلكتروني'),
                  subtitle: Text(account.email),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: const Text('رقم الهاتف'),
                  subtitle: Text(
                    account.phone,
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
