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
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        ),

        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 7, 30, 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 16),
                  Icon(Icons.sunny, size: 18, color: Colors.white),
                  SizedBox(width: 24),
                  Icon(Icons.dark_mode, size: 18, color: Colors.black),
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
                    isDark ? Icons.circle : Icons.sunny,
                    key: ValueKey(isDark),
                    size: 27,
                    color: isDark ? Colors.black : Colors.white,
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
