import 'package:flutter/material.dart';

class DrawerThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const DrawerThemeToggle({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 170,
        height: 40,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorScheme.tertiary,
        ),

        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 7, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 16),
                  Icon(Icons.sunny, size: 18, color: Colors.grey),
                  SizedBox(width: 24),
                  Icon(
                    Icons.dark_mode,
                    size: 18,
                    color: isDark
                        ? Colors.white
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),

            AnimatedAlign(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 85,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.surface.withOpacity(0.25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.sunny,
                    key: ValueKey(isDark),
                    size: 25,
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
