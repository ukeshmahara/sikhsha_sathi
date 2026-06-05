import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhsha_sathi/features/auth/presentation/pages/login_view.dart';
import 'onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
          () {

        final userBox =
        Hive.box('userBox');

        final isLoggedIn =
            userBox.get(
              'isLoggedIn',
              defaultValue: false,
            );

        if(isLoggedIn){

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const LoginView(),
            ),
          );

        } else {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const OnboardingPage(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),

            const SizedBox(height: 20),

            const Text(
              'ShikshaSathi',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}