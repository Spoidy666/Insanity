import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

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
      left: 20,
      right: 20,
      bottom: 6,

      child: LiquidGlass(
        shape: LiquidRoundedSuperellipse(borderRadius: 26),
        child: Container(
          height: 65,

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
              ? colorScheme.tertiary.withValues(alpha: 0.12)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: isActive ? 28 : 26,
          color: isActive
              ? colorScheme.tertiary
              : colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
