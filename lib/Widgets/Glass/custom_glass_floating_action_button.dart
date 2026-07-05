import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassFloatingActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const GlassFloatingActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LiquidGlass(
      shape: LiquidRoundedSuperellipse(borderRadius: 20),

      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 65,
          height: 65,
          child: Center(
            child: Icon(icon, color: colorScheme.tertiary, size: 30),
          ),
        ),
      ),
    );
  }
}
