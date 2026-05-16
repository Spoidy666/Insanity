import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuTap;
  final VoidCallback? onSettingsTap;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final bool isSettingsActive;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onMenuTap,
    this.onSettingsTap,
    this.showBackButton = false,
    this.onBackTap,
    this.isSettingsActive = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(title, key: ValueKey(title)),
      ),
      leading: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: showBackButton
            ? IconButton(
                key: const ValueKey('back'),
                icon: Icon(Iconsax.arrow_left_2),
                onPressed: onBackTap,
              )
            : IconButton(
                key: const ValueKey('menu'),
                icon: Icon(
                  Icons.menu_rounded,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                onPressed: onMenuTap,
              ),
      ),
      actions: [
        if (!showBackButton)
          IconButton(
            onPressed: onSettingsTap ?? () {},
            icon: Icon(
              Iconsax.setting_24,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
      ],
    );
  }
}
