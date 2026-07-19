import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/app/theme/theme_state.dart';

const String _kThemeModeKey = 'app_theme_mode';

// Below this lux value the room is considered "dark" and the app
// switches to dark theme while in Auto mode. Typical reference points:
// direct sunlight ~10,000+ lux, a lit room ~100-300 lux, dim room ~10-50 lux,
// a hand fully covering the sensor ~0-2 lux.
const double _kDarkLuxThreshold = 10;

final themeViewModelProvider =
    NotifierProvider<ThemeViewModel, ThemeState>(ThemeViewModel.new);

class ThemeViewModel extends Notifier<ThemeState> {
  late SharedPreferences _prefs;
  StreamSubscription<int>? _luxSubscription;

  @override
  ThemeState build() {
    _prefs = ref.read(sharedPreferencesProvider);

    ref.onDispose(() {
      _luxSubscription?.cancel();
    });

    final savedMode = _prefs.getString(_kThemeModeKey);
    final mode = AppThemeMode.values.firstWhere(
      (m) => m.name == savedMode,
      orElse: () => AppThemeMode.light,
    );

    if (mode == AppThemeMode.auto) {
      _startListeningToSensor();
    }

    return ThemeState(mode: mode);
  }

  Future<void> setMode(AppThemeMode mode) async {
    _luxSubscription?.cancel();
    _luxSubscription = null;

    await _prefs.setString(_kThemeModeKey, mode.name);
    state = state.copyWith(mode: mode);

    if (mode == AppThemeMode.auto) {
      _startListeningToSensor();
    }
  }

  Future<void> _startListeningToSensor() async {
    try {
      final hasSensor = await LightSensor.hasSensor();

      if (!hasSensor) {
        // No ambient light sensor on this device (common on iOS, or
        // some Android devices) — just fall back to light theme.
        return;
      }

      _luxSubscription = LightSensor.luxStream().listen((lux) {
        final isDark = lux < _kDarkLuxThreshold;

        if (isDark != state.isSensorDark) {
          state = state.copyWith(isSensorDark: isDark);
        }
      });
    } catch (_) {
      // sensor not available / platform doesn't support it — stay on
      // whatever theme is currently active rather than crashing
    }
  }
}