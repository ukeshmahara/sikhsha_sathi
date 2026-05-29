import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sikhsha_sathi/views/onboarding/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 80),

          // LOGO (TOP)
          Image.asset(
            'assets/images/logo.png',
            width: 160,
            height: 160,
          ),

          const SizedBox(height: 50),

          // APP NAME
          const Text(
            "ShikshaSathi",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E88E5),
            ),
          ),

          const SizedBox(height: 10),

          // SUBTITLE
          const Text(
            "Find the best school\nfor a bright future",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const Spacer(),

          // BOTTOM IMAGE
          Image.asset(
            'assets/images/splash_bg.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}