import 'package:flutter/material.dart';
import 'package:sikhsha_sathi/views/onboarding/splash_view.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprint1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const SplashView(),
    );
  }
}