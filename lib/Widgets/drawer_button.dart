import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spring_autumn/Theme/glass.dart';

class CustomDrawerButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final IconData i;
  final bool isActive;

  const CustomDrawerButton({
    super.key,
    required this.name,
    required this.onTap,
    required this.i,
    this.isActive = false,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<GlassConfig>(
      valueListenable: glassConfig,
      builder: (context, config, _) {
        final isGlass = config.drawer;

        if (!isGlass) {
          return SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? scheme.secondary : scheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    i,
                    color: isActive ? Colors.white : scheme.tertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    name,
                    style: TextStyle(
                      color: isActive ? Colors.white : scheme.tertiary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: isActive
                        ? [
                            scheme.tertiary.withValues(alpha: 0.25),
                            scheme.tertiary.withValues(alpha: 0.1),
                          ]
                        : [
                            scheme.primary.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.03),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: isActive
                        ? scheme.tertiary
                        : scheme.tertiary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(i, color: scheme.tertiary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      name,
                      style: TextStyle(
                        color: scheme.tertiary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
