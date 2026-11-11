import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NozulBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const NozulBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  static const _labels = ['الرئيسية', 'حجوزاتي', 'المفضلة', 'الحساب'];
  static const _icons = [
    Icons.home_outlined,
    Icons.calendar_month_outlined,
    Icons.favorite_border_rounded,
    Icons.person_outline_rounded,
  ];
  static const _selectedIcons = [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.favorite_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.darkGold;
    final activeIconColor = isDark ? AppColors.darkBackground : Colors.white;

    return SizedBox(
      height: 88,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 4;
          final isRtl = Directionality.of(context) == TextDirection.rtl;
          final targetPosition = isRtl ? 3 - selectedIndex : selectedIndex;

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: targetPosition.toDouble()),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOutCubic,
            builder: (context, position, child) {
              final circleCenter = itemWidth * (position + 0.5);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _NavigationBarPainter(
                          centerX: circleCenter,
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 0,
                    right: 0,
                    height: 64,
                    child: Row(
                      children: List.generate(4, (index) {
                        final isSelected = selectedIndex == index;
                        return Expanded(
                          child: Semantics(
                            label: _labels[index],
                            button: true,
                            selected: isSelected,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => onChanged(index),
                              child: Center(
                                child: isSelected
                                    ? const SizedBox.shrink()
                                    : Icon(
                                        _icons[index],
                                        size: 27,
                                        color: theme.colorScheme.onSurface
                                            .withAlpha(150),
                                      ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: circleCenter - 25,
                    width: 50,
                    height: 50,
                    child: ExcludeSemantics(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onChanged(selectedIndex),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: goldColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              _selectedIcons[selectedIndex],
                              color: activeIconColor,
                              size: 27,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _NavigationBarPainter extends CustomPainter {
  final double centerX;
  final Color color;

  const _NavigationBarPainter({required this.centerX, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final barPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(0, 18, size.width, 82),
          const Radius.circular(26),
        ),
      );
    final notchPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(centerX, 25), radius: 31));
    final finalPath = Path.combine(
      PathOperation.difference,
      barPath,
      notchPath,
    );
    canvas.drawPath(
      finalPath,
      Paint()
        ..color = color
        ..isAntiAlias = true
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _NavigationBarPainter oldDelegate) {
    return oldDelegate.centerX != centerX || oldDelegate.color != color;
  }
}
