import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const CustomFloatingActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 65,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        enableFeedback: true,
        elevation: 2,
        onPressed: onTap,
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.tertiary,
          size: 30,
        ),
      ),
    );
  }
}
