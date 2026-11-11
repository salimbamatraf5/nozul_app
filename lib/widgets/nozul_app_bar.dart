import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NozulAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isHome;
  final VoidCallback? onAccountPressed;
  final VoidCallback? onMenuPressed;

  const NozulAppBar({
    super.key,
    this.title,
    this.isHome = false,
    this.onAccountPressed,
    this.onMenuPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(isHome ? 85 : kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.darkGold;
    final surfaceColor = isDark
        ? AppColors.DarkSurface
        : AppColors.lightSurface;

    return AppBar(
      backgroundColor: surfaceColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: preferredSize.height,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: isHome
          ? Image.asset('images/image.png', height: 65)
          : Text(title ?? ''),
      leadingWidth: isHome ? 140 : null,
      leading: isHome
          ? Row(
              children: [
                const SizedBox(width: 10),
                IconButton(
                  onPressed: onAccountPressed,
                  icon: Icon(Icons.person, color: goldColor, size: 35),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'زائر',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'مساء الخير',
                        maxLines: 1,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : null,
      actions: [
        if (onMenuPressed != null)
          Semantics(
            label: 'القائمة الجانبية',
            child: IconButton(
              onPressed: onMenuPressed,
              icon: const Icon(Icons.menu),
            ),
          ),
      ],
    );
  }
}
