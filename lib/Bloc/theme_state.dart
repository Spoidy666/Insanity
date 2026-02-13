import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spring_autumn/Theme/theme.dart';

/// =========================
/// EVENTS
/// =========================

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class LoadTheme extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class EnableDarkMode extends ThemeEvent {}

class EnableLightMode extends ThemeEvent {}

class ToggleAccent extends ThemeEvent {}

class ChangeAccentColor extends ThemeEvent {
  final Color color;
  const ChangeAccentColor(this.color);

  @override
  List<Object?> get props => [color];
}

/// =========================
/// STATE
/// =========================

class ThemeState extends Equatable {
  final bool isDark;
  final Color accentColor;
  final bool useAccent;

  const ThemeState({
    required this.isDark,
    required this.accentColor,
    required this.useAccent,
  });
  ThemeData get themeData {
    final baseTheme = isDark ? darkmode : lightmode;

    if (!useAccent) return baseTheme;

    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        tertiary: accentColor,
        secondary: accentColor.withValues(alpha: 0.4),
      ),
    );
  }

  Color complementary(Color color) {
    final hsl = HSLColor.fromColor(color);
    final newHue = (hsl.hue + 180) % 360;
    return hsl.withHue(newHue).toColor();
  }

  @override
  List<Object?> get props => [isDark, accentColor, useAccent];
}

/// =========================
/// BLOC
/// =========================

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const _themeKey = 'isDarkMode';
  static const _accentKey = 'accentColor';
  static const _useAccentKey = 'useAccent';

  ThemeBloc()
    : super(
        const ThemeState(
          isDark: false,
          accentColor: Colors.blue,
          useAccent: false,
        ),
      ) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<EnableDarkMode>(_onEnableDarkMode);
    on<EnableLightMode>(_onEnableLightMode);
    on<ToggleAccent>(_onToggleAccent);
    on<ChangeAccentColor>(_onChangeAccentColor);

    add(LoadTheme());
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();

    emit(
      ThemeState(
        isDark: prefs.getBool(_themeKey) ?? false,
        accentColor: Color(prefs.getInt(_accentKey) ?? Colors.blue.value),
        useAccent: prefs.getBool(_useAccentKey) ?? false,
      ),
    );
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final newIsDark = !state.isDark;

    emit(
      ThemeState(
        isDark: newIsDark,
        accentColor: state.accentColor,
        useAccent: state.useAccent,
      ),
    );

    await prefs.setBool(_themeKey, newIsDark);
  }

  Future<void> _onEnableDarkMode(
    EnableDarkMode event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    emit(
      ThemeState(
        isDark: true,
        accentColor: state.accentColor,
        useAccent: state.useAccent,
      ),
    );

    await prefs.setBool(_themeKey, true);
  }

  Future<void> _onEnableLightMode(
    EnableLightMode event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    emit(
      ThemeState(
        isDark: false,
        accentColor: state.accentColor,
        useAccent: state.useAccent,
      ),
    );

    await prefs.setBool(_themeKey, false);
  }

  Future<void> _onToggleAccent(
    ToggleAccent event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final newValue = !state.useAccent;

    emit(
      ThemeState(
        isDark: state.isDark,
        accentColor: state.accentColor,
        useAccent: newValue,
      ),
    );

    await prefs.setBool(_useAccentKey, newValue);
  }

  Future<void> _onChangeAccentColor(
    ChangeAccentColor event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    emit(
      ThemeState(
        isDark: state.isDark,
        accentColor: event.color,
        useAccent: true,
      ),
    );

    await prefs.setInt(_accentKey, event.color.value);
    await prefs.setBool(_useAccentKey, true);
  }
}
