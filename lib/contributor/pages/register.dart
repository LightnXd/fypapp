import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/authentication.dart';
import '../../widget/otp_confirmation.dart';
import '../../widget/question_box.dart';
import '../../widget/date_picker.dart';
import '../../widget/empty_box.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthenticationService _authService = AuthenticationService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final confirmEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final countryController = TextEditingController();
  final ageController = TextEditingController();
  final birthdateController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmEmailError;
  String? confirmPasswordError;

  bool validateInputs() {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmEmail = confirmEmailController.text;
    final confirmPassword = confirmPasswordController.text;

    final passwordValid = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,24}$',
    );

    setState(() {
      nameError = name.length >= 5
          ? null
          : 'Name must be at least 5 characters';
      emailError = email.contains('@') ? null : 'Invalid email address';
      confirmEmailError = email == confirmEmail ? null : 'Email does not match';
      passwordError = passwordValid.hasMatch(password)
          ? null
          : 'Need to be within 8–24 characters\nAt least 1 uppercase\nAt least 1 lowercase\nAt least 1 number\nAt least 1 symbol';
      confirmPasswordError = password == confirmPassword
          ? null
          : 'Password does not match';
    });

    return name.length >= 5 &&
        email.contains('@') &&
        email == confirmEmail &&
        passwordValid.hasMatch(password) &&
        password == confirmPassword;
  }

  @override
  void dispose() {
    emailController.dispose();
    confirmEmailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    countryController.dispose();
    ageController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Name:',
              hint: 'Enter your name',
              controller: nameController,
              errorText: nameError,
            ),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Email:',
              hint: 'Enter your email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: emailError,
            ),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Confirm Email:',
              hint: 'Re-enter your email',
              controller: confirmEmailController,
              keyboardType: TextInputType.emailAddress,
              errorText: confirmEmailError,
            ),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Password:',
              hint: 'Enter your password',
              controller: passwordController,
              hidden: true,
              showPassword: showPassword,
              onTogglePassword: () =>
                  setState(() => showPassword = !showPassword),
              errorText: passwordError,
            ),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Confirm Password:',
              hint: 'Re-enter your password',
              controller: confirmPasswordController,
              hidden: true,
              showPassword: showConfirmPassword,
              onTogglePassword: () =>
                  setState(() => showConfirmPassword = !showConfirmPassword),
              errorText: confirmPasswordError,
            ),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Country:',
              hint: 'Enter your country',
              // controller: countryController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0, top: 7),
                    child: Image(
                      image: AssetImage('assets/images/test.webp'),
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Birthdate:',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: DatePickerDropdown(
                      hint: "Select your birthdate",
                      controller: birthdateController,
                    ),
                  ),
                ],
              ),
            ),
            gaph28,
            ElevatedButton(
              onPressed: () async {
                if (validateInputs()) {
                  try {
                    final shouldVerify = await _authService.signUp(
                      emailController.text,
                    );
                    if (shouldVerify) {
                      await OtpDialog.show(
                        context: context,
                        onSubmitted: (otp, onResult) async {
                          try {
                            final response = await http.post(
                              Uri.parse(
                                "http://10.101.39.125:8000/auth/verify-otp",
                              ),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({
                                'email': emailController.text,
                                'token': otp,
                                'type': 'email',
                              }),
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
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('This email is already confirmed.'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Signup error: $e')));
                  }
                }
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
