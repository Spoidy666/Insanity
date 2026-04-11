import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            [
              _NavItem(icon: Iconsax.home_2, index: 0, label: 'Home'),
              _NavItem(icon: Iconsax.wallet, index: 1, label: 'Wallet'),
              _NavItem(icon: Iconsax.money, index: 2, label: 'Expenses'),
              _NavItem(icon: Iconsax.wallet_money, index: 3, label: 'Savings'),
              _NavItem(icon: Iconsax.graph, index: 4, label: 'Plan'),
            ].map((item) {
              return item.build(
                context: context,
                isActive: currentIndex == item.index,
                onTap: () => onTap(item.index),
              );
            }).toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final int index;
  final String label;

  _NavItem({required this.icon, required this.index, required this.label});

  Widget build({
    required BuildContext context,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(0, isActive ? -4 : 0, 0),
              child: Icon(
                icon,
                size: isActive ? 27 : 24,
                color: isActive
                    ? colorScheme.tertiary
                    : colorScheme.onSurface.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 4),

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 0,
              width: isActive ? 16 : 0,
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 4),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                color: isActive
                    ? colorScheme.tertiary
                    : colorScheme.onSurface.withOpacity(0.6),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
