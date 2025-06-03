import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/pages/register.dart';
import 'package:fypapp2/services/authentication.dart';
import 'package:fypapp2/widget/empty_box.dart';
import 'package:fypapp2/widget/otp_confirmation.dart';
import 'package:fypapp2/widget/question_box.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final AuthenticationService _authService = AuthenticationService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  String? errordata;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool validateInputs() {
    final email = emailController.text;
    final password = passwordController.text;
    final passwordValid = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,24}$',
    );
    setState(() {
      emailError = email.contains('@') ? null : 'Invalid email address';
      passwordError = passwordValid.hasMatch(password)
          ? null
          : 'Need to be within 8–24 characters\nAt least 1 uppercase\nAt least 1 lowercase\nAt least 1 number\nAt least 1 symbol';
    });
        return email.contains('@');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login Page',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              gaph40,
              /*Image.asset(
                'assets/logo.png', // Place your logo in the assets folder
                height: 100,
              ),*/
              gaph40,
              QuestionBox(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: emailError,
              ),
              QuestionBox(
                label: 'Password',
                hint: 'Enter your password',
                controller: passwordController,
                errorText: passwordError,
              ),
              if (errordata != null)
                gaph10,
              Text(
                errordata!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              gaph28,
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    errordata = null;
                  });
                  if (validateInputs()) {
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    try {
                      final result = await _authService.verifyUser(email, password);
                      final verified = result['status'];

                      if (!verified) {
                        setState(() {
                          errordata = result['message'];
                        });
                        return;
                      }
                      try {
                        await _authService.sendOTP(email);
                        await OtpDialog.show(
                          context: context,
                          onSubmitted: (otp, onResult) async {
                            try {
                              final response = await _authService.verifyOTP(
                                email: emailController.text,
                                otp: otp,
                              );
                              final data = jsonDecode(response.body);

                              if (response.statusCode == 200) {
                                onResult(null);
                                final success = await _authService.getSession(data['session_string']);
                                if (success) {
                                  Navigator.pushReplacementNamed(context, '/home');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to restore session')),
                                  );
                                }
                              } else {
                                onResult(data['error'] ?? 'Verification failed');
                              }
                            } catch (e) {
                              onResult('An error occurred: $e');
                            }
                          },
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to send OTP: $e')),
                        );
                      }
                    } catch (e) {
                      print("Error: $e");
                    }
                  }
                },
                child: const Text('Login'),
              ),
              gaph20,
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text(
                  'No account? Register now',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await OtpDialog.show(
                    context: context,
                    onSubmitted: (otp, onResult) async {
                    },
                  );
                },
                child: const Text("Test"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

