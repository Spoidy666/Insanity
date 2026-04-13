import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlassConfig {
  final bool navbar;
  final bool fab;
  final bool button;
  final bool snackbar;
  final bool drawer;

  const GlassConfig({
    required this.navbar,
    required this.fab,
    required this.button,
    required this.snackbar,
    required this.drawer,
  });

  GlassConfig copyWith({
    bool? navbar,
    bool? fab,
    bool? button,
    bool? snackbar,
    bool? drawer,
  }) {
    return GlassConfig(
      navbar: navbar ?? this.navbar,
      fab: fab ?? this.fab,
      button: button ?? this.button,
      snackbar: snackbar ?? this.snackbar,
      drawer: drawer ?? this.drawer,
    );
  }
}

ValueNotifier<GlassConfig> glassConfig = ValueNotifier(
  const GlassConfig(
    navbar: false,
    fab: false,
    button: false,
    snackbar: false,
    drawer: false,
  ),
);

Future<void> saveGlassConfig(GlassConfig config) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('glass_navbar', config.navbar);
  await prefs.setBool('glass_fab', config.fab);
  await prefs.setBool('glass_button', config.button);
  await prefs.setBool('glass_snackbar', config.snackbar);
  await prefs.setBool('glass_drawer', config.drawer);
}

Future<void> loadGlassConfig() async {
  final prefs = await SharedPreferences.getInstance();

  glassConfig.value = GlassConfig(
    navbar: prefs.getBool('glass_navbar') ?? false,
    fab: prefs.getBool('glass_fab') ?? false,
    button: prefs.getBool('glass_button') ?? false,
    snackbar: prefs.getBool('glass_snackbar') ?? false,
    drawer: prefs.getBool('glass_drawer') ?? false,
  );
}
