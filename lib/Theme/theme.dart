import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Quicksand',

  colorScheme: ColorScheme.light(
    surface: const Color.fromRGBO(247, 247, 247, 1.0),
    primary: Colors.grey.shade300,
    secondary: Colors.grey.shade700,
    tertiary: Colors.black,
  ),
);
ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Quicksand',
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.grey.shade900,
    secondary: Colors.grey.shade600,
    tertiary: Colors.white,
  ),
);
