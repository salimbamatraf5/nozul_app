import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.lightText : AppColors.darkText;
    // final backgroundColor = isDark
    // ? AppColors.darkBackground
    // : AppColors.lightBackgtound;
    final goldColor = isDark ? AppColors.gold : AppColors.darkGold;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/hotel.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.black,
                        Colors.black.withValues(alpha: 0.70),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.70),
                        Colors.black,
                      ]
                    : [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.7),
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.70),
                        Colors.white,
                      ],
                stops: const [0, 0.3, 0.55, .78, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'images/image.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "أهلاً بك في نُزُل",
                    style: TextStyle(
                      fontSize: 27,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "اكتشف واحجز أفخم الفنادق\nوأحدثها حول العالم",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: goldColor,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: Text(
                        "ابدأ الآن كزائر",
                        style: TextStyle(fontSize: 19),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: goldColor, width: 2),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "تسجيل الدخول",
                        style: TextStyle(fontSize: 19, color: goldColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ليس لديك حساب ؟",
                        style: TextStyle(color: textColor),
                      ),
                      TextButton(
                        onPressed: () async {
                          final account =
                              await Navigator.push<RegistrationData>(
                                context,
                                MaterialPageRoute<RegistrationData>(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );

                          if (!context.mounted || account == null) return;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HomeScreen(initialAccount: account),
                            ),
                          );
                        },
                        child: Text(
                          "إنشاء حساب",
                          style: TextStyle(
                            color: goldColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "أو سجل الدحول بواسطة ",
                    style: TextStyle(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.facebook,
                            color: goldColor,
                            size: 35,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.g_mobiledata,
                            color: goldColor,
                            size: 48,
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.apple, color: goldColor, size: 35),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
