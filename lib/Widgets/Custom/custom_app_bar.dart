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
          _SpinningSettingsButton(
            onTap: onSettingsTap ?? () {},
            isActive: isSettingsActive,
          ),
      ],
    );
  }
}

class _SpinningSettingsButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isActive;

  const _SpinningSettingsButton({required this.onTap, required this.isActive});

  @override
  State<_SpinningSettingsButton> createState() =>
      _SpinningSettingsButtonState();
}

class _SpinningSettingsButtonState extends State<_SpinningSettingsButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _rotation = Tween<double>(begin: 0, end: -1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void didUpdateWidget(_SpinningSettingsButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onTap,
      icon: AnimatedBuilder(
        animation: _rotation,
        builder: (context, child) => Transform.rotate(
          angle: _rotation.value * 2 * 3.14159,
          child: child,
        ),
        child: Icon(
          Iconsax.setting_24,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
