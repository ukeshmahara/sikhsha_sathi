
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  final _passwordCtrl =
      TextEditingController();

  final _confirmPasswordCtrl =
      TextEditingController();

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  // ================= SIGNUP =================

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

        // ================= SUCCESS =================

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

          Navigator.pop(context);
        }

        // ================= ERROR =================

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
      backgroundColor: Colors.white,

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

                // ================= TITLE =================

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

                // ================= FULL NAME =================

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

                // ================= EMAIL =================

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

                      return 'Enter valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ================= PASSWORD =================

                TextFormField(
                  controller: _passwordCtrl,

                  obscureText: true,

                  decoration: InputDecoration(
                    labelText: 'Password',

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

                // ================= CONFIRM PASSWORD =================

                TextFormField(
                  controller:
                      _confirmPasswordCtrl,

                  obscureText: true,

                  decoration: InputDecoration(
                    labelText:
                        'Confirm Password',

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

                // ================= BUTTON =================

                SizedBox(
                  height: 50,

                  child: ElevatedButton(

                    onPressed:
                        authState.status ==
                                AuthStatus.loading
                            ? null
                            : _signup,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),

                    child:
                        authState.status ==
                                AuthStatus.loading

                            ? const CircularProgressIndicator(
                                color:
                                    Colors.white,
                              )

                            : const Text(
                                'Register',

                                style: TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                  ),
                ),

                const SizedBox(height: 35),

                // ================= LOGIN =================

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
