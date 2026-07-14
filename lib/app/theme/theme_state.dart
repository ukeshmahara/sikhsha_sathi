import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// The mode the USER picked in settings
enum AppThemeMode { light, dark, auto }

class ThemeState extends Equatable {
  final AppThemeMode mode;

  // Only meaningful when mode == auto — whether the sensor currently
  // thinks the room is dark or bright.
  final bool isSensorDark;

  const ThemeState({
    this.mode = AppThemeMode.light,
    this.isSensorDark = false,
  });

  // What MaterialApp should actually render right now, given the
  // current mode and (if in auto mode) the last sensor reading.
  ThemeMode get themeMode {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.auto:
        return isSensorDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  ThemeState copyWith({
    AppThemeMode? mode,
    bool? isSensorDark,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      isSensorDark: isSensorDark ?? this.isSensorDark,
    );
  }

  @override
  List<Object?> get props => [mode, isSensorDark];
}