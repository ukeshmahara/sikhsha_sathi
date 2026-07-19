import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';

import 'core/services/hive/hive_service.dart';
import 'core/services/storage/user_session_service.dart';

Future<void> main() async {

WidgetsFlutterBinding.ensureInitialized();

// Make the status bar transparent with light (white) icons, so it blends
// into the blue headers used across Home, Favourite, Compare and Profile
// instead of showing as a separate white strip above them.
SystemChrome.setSystemUIOverlayStyle(
  const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light, // white icons on Android
    statusBarBrightness: Brightness.dark,       // white icons on iOS
  ),
);

// Initialize Hive
await HiveService().init();

// Initialize SharedPreferences
final sharedPreferences =
await SharedPreferences.getInstance();

runApp(
ProviderScope(
overrides: [
sharedPreferencesProvider
.overrideWithValue(
sharedPreferences,
),
],
child: const App(),
),
);
}