import 'package:flutter/material.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import 'theme/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShikshaSathi',
      theme: getApplicationTheme(),
      home: const SplashPage(),
    );
  }
}