import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/app/theme/app_colors.dart';
import 'login_view.dart';
import '../state/auth_state.dart';
import '../view_model/auth_view_model.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() =>
      _SignupViewState();
}

class _SignupViewState
    extends ConsumerState<SignupView> {

  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl =
      TextEditingController();

  final _emailCtrl =
      TextEditingController();

  final _phoneCtrl =
      TextEditingController();

  final _passwordCtrl =
      TextEditingController();

  final _confirmPasswordCtrl =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {

    if (_formKey.currentState!
        .validate()) {

      await ref
          .read(
        authViewModelProvider.notifier,
      )
          .register(
        fullName:
            _fullNameCtrl.text.trim(),

        email:
            _emailCtrl.text.trim(),

        phoneNumber:
            _phoneCtrl.text.trim(),

        password:
            _passwordCtrl.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final authState =
        ref.watch(authViewModelProvider);

    ref.listen<AuthState>(
      authViewModelProvider,
      (previous, next) {

        if (next.status ==
            AuthStatus.registered) {

          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text(
                'Account created successfully',
              ),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const LoginView(),
            ),
          );
        }

        if (next.status ==
            AuthStatus.error) {

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                next.errorMessage ??
                    'Signup Failed',
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
            horizontal: 24,
            vertical: 40,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,

              children: [

                const SizedBox(height: 20),

                const Center(
                  child: Column(
                    children: [

                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        'Join SikhshaSathi',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                TextFormField(
                  controller: _fullNameCtrl,

                  decoration: InputDecoration(
                    labelText: 'Full Name',

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return
                          'Please enter full name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _emailCtrl,

                  keyboardType:
                      TextInputType.emailAddress,

                  decoration: InputDecoration(
                    labelText: 'Email',

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return
                          'Please enter email';
                    }

                    final emailValid = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(value);

                    if (!emailValid) {

                      return
                          'Enter valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _phoneCtrl,

                  keyboardType:
                      TextInputType.phone,

                  decoration: InputDecoration(
                    labelText: 'Phone Number',

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return
                          'Please enter phone number';
                    }

                    if (value.length < 10) {

                      return
                          'Enter valid phone number';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller:
                      _passwordCtrl,

                  obscureText:
                      _obscurePassword,

                  decoration: InputDecoration(
                    labelText:
                        'Password',

                    suffixIcon:
                        IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.isEmpty) {

                      return
                          'Please enter password';
                    }

                    if (value.length < 6) {

                      return
                          'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller:
                      _confirmPasswordCtrl,

                  obscureText:
                      _obscureConfirmPassword,

                  decoration: InputDecoration(
                    labelText:
                        'Confirm Password',

                    suffixIcon:
                        IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),

                  validator: (value) {

                    if (value !=
                        _passwordCtrl.text) {

                      return
                          'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 50,

                  child: ElevatedButton(
                    onPressed:
                        authState.status ==
                                AuthStatus.loading
                            ? null
                            : _signup,

                    child:
                        authState.status ==
                                AuthStatus.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Register',
                              ),
                  ),
                ),

                const SizedBox(height: 35),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    const Text(
                      'Already have an account ? ',
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}