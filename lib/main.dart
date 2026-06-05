
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

import 'core/services/hive/hive_service.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive Service
  final hiveService = HiveService();

  await hiveService.init();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
