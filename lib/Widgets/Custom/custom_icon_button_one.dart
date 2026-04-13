import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spring_autumn/Theme/glass.dart';

class CustomIconButtonOne extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const CustomIconButtonOne({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<GlassConfig>(
      valueListenable: glassConfig,
      builder: (context, config, _) {
        final isGlass = config.button;

        if (!isGlass) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: onTap,
            child: Icon(icon, size: 25, color: scheme.tertiary),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0.03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: scheme.tertiary.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child: Icon(icon, size: 25, color: scheme.tertiary),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
