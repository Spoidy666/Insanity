import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Settings/settings_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuTap;

  const CustomAppBar({super.key, required this.title, required this.onMenuTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: Icon(
          Icons.menu_rounded,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        onPressed: onMenuTap,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Iconsax.setting_24,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
          },
        ),
      ],
    );
  }
}
