import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spring_autumn/Theme/theme.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class LoadTheme extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class EnableDarkMode extends ThemeEvent {}

class EnableLightMode extends ThemeEvent {}



class ThemeState extends Equatable {
  final ThemeData themeData;

  const ThemeState(this.themeData);

  @override
  List<Object?> get props => [themeData];
}


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const _themeKey = 'isDarkMode';

  ThemeBloc() : super( ThemeState(lightmode)) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<EnableDarkMode>(_onEnableDarkMode);
    on<EnableLightMode>(_onEnableLightMode);

    add(LoadTheme());
  }

  Future<void> _onLoadTheme(
    LoadTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    emit(ThemeState(isDark ? darkmode : lightmode));
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = state.themeData.brightness == Brightness.dark;

    final newTheme = isDark ? lightmode : darkmode;
    emit(ThemeState(newTheme));
    await prefs.setBool(_themeKey, !isDark);
  }

  Future<void> _onEnableDarkMode(
    EnableDarkMode event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    emit( ThemeState(darkmode));
    await prefs.setBool(_themeKey, true);
  }

  Future<void> _onEnableLightMode(
    EnableLightMode event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    emit( ThemeState(lightmode));
    await prefs.setBool(_themeKey, false);
  }
}
