import 'package:flutter/material.dart';

class CustomPrimaryText extends StatelessWidget {
  final String text;
  final double size;
  const CustomPrimaryText({super.key, required this.text, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: size),
    );
  }
}
