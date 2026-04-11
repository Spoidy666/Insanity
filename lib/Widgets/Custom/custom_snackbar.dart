import 'dart:ui';
import 'package:flutter/material.dart';

enum SnackbarType { success, error, neutral }

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackbarType type = SnackbarType.neutral,
    bool top = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final theme = Theme.of(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    Color bgColor;
    switch (type) {
      case SnackbarType.success:
        bgColor = Colors.lightGreenAccent;
        break;
      case SnackbarType.error:
        bgColor = Colors.red;
        break;
      case SnackbarType.neutral:
        bgColor = theme.colorScheme.tertiary;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: top
            ? EdgeInsets.only(bottom: screenHeight - 200, left: 0, right: 0)
            : const EdgeInsets.only(bottom: 20, left: 0, right: 0),

        content: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
