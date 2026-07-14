import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sikhsha_sathi/app/theme/app_colors.dart';
import 'package:sikhsha_sathi/core/services/biometric/biometric_service.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/dashboard/presentation/pages/dashboard_page.dart';
import 'forgot_password_page.dart';
import 'signup_view.dart';

import '../state/auth_state.dart';
import '../view_model/auth_view_model.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState()
      => _LoginViewState();
}

class _LoginViewState
    extends ConsumerState<LoginView> {

  final _formKey =
  GlobalKey<FormState>();

  final TextEditingController
  _emailCtrl =
  TextEditingController();

  final TextEditingController
  _passwordCtrl =
  TextEditingController();

  bool _obscure = true;
  bool _showBiometricButton = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final session = ref.read(userSessionServiceProvider);

    if (!session.isBiometricLoginEnabled()) {
      return;
    }

    final biometricService = ref.read(biometricServiceProvider);
    final canUse = await biometricService.canCheckBiometrics();

    if (mounted) {
      setState(() {
        _showBiometricButton = canUse;
      });
    }
  }

  Future<void> _loginWithBiometric() async {
    await ref.read(authViewModelProvider.notifier).loginWithBiometric();
  }

  @override
  void dispose() {

    _emailCtrl.dispose();
    _passwordCtrl.dispose();

    super.dispose();
  }

  Future<void> login() async {

    if (_formKey.currentState!
        .validate()) {

      await ref
          .read(
          authViewModelProvider.notifier)
          .login(
        email:
        _emailCtrl.text.trim(),

        password:
        _passwordCtrl.text.trim(),
      );
    }
  }

  void goToSignup() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const SignupView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final authState =
    ref.watch(authViewModelProvider);

    ref.listen<AuthState>(
      authViewModelProvider,
          (previous, next) {

        // LOGIN SUCCESS
        if (next.status ==
            AuthStatus.authenticated) {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const DashboardPage(),
            ),
          );
        }

        // LOGIN ERROR
        if (next.status ==
            AuthStatus.error) {

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                next.errorMessage ??
                    'Login Failed',
              ),
            ),
          );
        }
      },
    );

    return Scaffold(

      backgroundColor: context.appBackground,

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 30,
          ),

          child: Form(

            key: _formKey,

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 30),

                // WELCOME
                const Text(
                  "Welcome",

                  style: TextStyle(
                    fontSize: 34,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // IMAGE
                Center(
                  child: Image.asset(
                    'assets/images/login.png',
                    height: 200,
                  ),
                ),

                const SizedBox(height: 40),

                // EMAIL TEXT
                const Text(
                  "Email",

                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                // EMAIL FIELD
                TextFormField(

                  controller:
                  _emailCtrl,

                  decoration:
                  InputDecoration(

                    hintText:
                    "Enter your email",

                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.isEmpty) {

                      return
                      "Please enter email";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // PASSWORD TEXT
                const Text(
                  "Password",

                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                // PASSWORD FIELD
                TextFormField(

                  controller:
                  _passwordCtrl,

                  obscureText:
                  _obscure,

                  decoration:
                  InputDecoration(

                    hintText:
                    "Enter your password",

                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),

                    suffixIcon:
                    IconButton(

                      icon: Icon(
                        _obscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),

                      onPressed: () {

                        setState(() {
                          _obscure =
                          !_obscure;
                        });
                      },
                    ),
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.isEmpty) {

                      return
                      "Please enter password";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // FORGOT PASSWORD
                Align(

                  alignment:
                  Alignment.centerRight,

                  child: TextButton(

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },

                    child: const Text(
                      "Forgot Password ?",

                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // LOGIN BUTTON
                SizedBox(

                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed:
                    authState.status ==
                        AuthStatus.loading
                        ? null
                        : login,

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      Colors.blue,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),

                    child:
                    authState.status ==
                        AuthStatus.loading

                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )

                        : const Text(
                      "Login",

                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // FINGERPRINT LOGIN — only shown if the user enabled it
                // from Profile and this device supports biometrics
                if (_showBiometricButton)
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: authState.status == AuthStatus.loading
                              ? null
                              : _loginWithBiometric,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 1.5),
                            ),
                            child: const Icon(
                              Icons.fingerprint,
                              size: 36,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Login with fingerprint",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 30),

                // CONTINUE WITH
                const Center(
                  child: Text(
                    "or continue with",

                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // SOCIAL ICONS
                Row(

                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,

                  children: const [

                    Icon(
                      Icons.facebook,
                      color: Colors.blue,
                      size: 40,
                    ),

                    Icon(
                      Icons.g_mobiledata,
                      color: Colors.red,
                      size: 50,
                    ),

                    Icon(
                      Icons.apple,
                      color: Colors.black,
                      size: 40,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // SIGNUP
                Row(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    const Text(
                      "Don't have an account ? ",
                    ),

                    GestureDetector(

                      onTap:
                      goToSignup,

                      child: const Text(

                        "SignUp",

                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}