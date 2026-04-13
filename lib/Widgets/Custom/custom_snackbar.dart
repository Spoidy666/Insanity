import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spring_autumn/Theme/glass.dart';

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
    final config = glassConfig.value;

    Color bgColor;
    switch (type) {
      case SnackbarType.success:
        bgColor = Colors.lightGreen;
        break;
      case SnackbarType.error:
        bgColor = Colors.red;
        break;
      case SnackbarType.neutral:
        bgColor = theme.colorScheme.tertiary;
        break;
    }

    if (!config.snackbar) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: bgColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: top
              ? EdgeInsets.only(bottom: screenHeight - 200, left: 16, right: 16)
              : const EdgeInsets.all(16),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: top
            ? EdgeInsets.only(bottom: screenHeight - 200, left: 0, right: 0)
            : const EdgeInsets.only(bottom: 20),

        content: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
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
