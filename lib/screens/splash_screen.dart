import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 3),
            Image.asset('images/image.png', width: 210),
            const Spacer(flex: 2),
            Text(
              "تطوير\nفريق الصناديد",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? AppColors.gold : AppColors.darkGold,
                fontSize: 17,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
