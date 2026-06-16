import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/presentation/pages/dashboard_page.dart';

import '../../../../core/services/storage/user_session_service.dart';

import 'onboarding_page.dart';

class SplashPage extends ConsumerStatefulWidget {
const SplashPage({super.key});

@override
ConsumerState<SplashPage> createState() =>
_SplashPageState();
}

class _SplashPageState
extends ConsumerState<SplashPage> {

@override
void initState() {
super.initState();

_navigate();

}

Future<void> _navigate() async {

await Future.delayed(
  const Duration(seconds: 2),
);

if (!mounted) return;

final userSessionService =
    ref.read(
  userSessionServiceProvider,
);

final isLoggedIn =
    userSessionService.isLoggedIn();

if (isLoggedIn) {

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const DashboardPage(),
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

        const SizedBox(
          height: 20,
        ),

        const Text(
          'ShikshaSathi',
          style: TextStyle(
            fontSize: 30,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
);


}
}
