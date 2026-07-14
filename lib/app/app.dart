import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import 'theme/theme_data.dart';
import 'theme/theme_view_model.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShikshaSathi',
      theme: getApplicationTheme(),
      darkTheme: getApplicationDarkTheme(),
      themeMode: themeState.themeMode,
      home: const SplashPage(),
    );
  }
}