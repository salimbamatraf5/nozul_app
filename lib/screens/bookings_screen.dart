import 'package:flutter/material.dart';

import '../widgets/nozul_app_bar.dart';

class BookingsScreen extends StatelessWidget {
  final VoidCallback? onMenuPressed;

  const BookingsScreen({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NozulAppBar(title: 'حجوزاتي', onMenuPressed: onMenuPressed),
      body: const SizedBox.expand(),
    );
  }
}
