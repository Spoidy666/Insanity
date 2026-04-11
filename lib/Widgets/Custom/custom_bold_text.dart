import 'package:flutter/material.dart';

class CustomBoldText extends StatelessWidget {
  final String text;
  final double size;
  const CustomBoldText({super.key, required this.text, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: size),
    );
  }
}
