import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FloatingGlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingGlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 6,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.04),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.tertiary.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  [
                    _NavItem(icon: Iconsax.home_2, index: 0),
                    _NavItem(icon: Iconsax.wallet, index: 1),
                    _NavItem(icon: Iconsax.money, index: 2),
                    _NavItem(icon: Iconsax.wallet_money, index: 3),
                    _NavItem(icon: Iconsax.graph, index: 4),
                  ].map((item) {
                    return item.build(
                      context: context,
                      isActive: currentIndex == item.index,
                      onTap: () => onTap(item.index),
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final int index;

  _NavItem({required this.icon, required this.index});

  Widget build({
    required BuildContext context,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive
              ? colorScheme.tertiary.withValues(alpha: 0.15)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 26,
          color: isActive
              ? colorScheme.tertiary
              : colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
