import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 50,
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
            Icon(i, color: isActive ? Colors.white : scheme.tertiary, size: 20),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                color: isActive ? Colors.white : scheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
