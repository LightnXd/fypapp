import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/authentication.dart';
import '../../widget/otp_confirmation.dart';
import '../../widget/question_box.dart';
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
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmEmailError;
  String? confirmPasswordError;
  String? addressError;
  String? countryError;
  String? descriptionError;

  bool validateInputs() {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmEmail = confirmEmailController.text;
    final confirmPassword = confirmPasswordController.text;
    final confirmCountry = countryController.text;
    final confirmAddress = addressController.text;
    final confirmDescription = descriptionController.text;

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

      // NEW: Empty field validations
      countryError = confirmCountry.isNotEmpty
          ? null
          : 'Country must not be empty';
      addressError = confirmAddress.isNotEmpty
          ? null
          : 'Address must not be empty';
      descriptionError = confirmDescription.isNotEmpty
          ? null
          : 'Description must not be empty';
    });

    return name.length >= 5 &&
        email.contains('@') &&
        email == confirmEmail &&
        passwordValid.hasMatch(password) &&
        password == confirmPassword &&
        confirmCountry.isNotEmpty &&
        confirmAddress.isNotEmpty &&
        confirmDescription.isNotEmpty;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    confirmEmailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    countryController.dispose();
    descriptionController.dispose();
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
              label: 'Address:',
              hint: 'Enter your address',
              controller: addressController,
              errorText: addressError,
            ),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Country:',
              hint: 'Enter your country',
              controller: countryController,
              errorText: countryError,
            ),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Description:',
              hint: 'Description',
              controller: descriptionController,
              errorText: descriptionError,
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
                            final response = await _authService.verifyOTP(
                              email: emailController.text,
                              otp: otp,
                            );
                            final data = jsonDecode(response.body);

                            if (response.statusCode == 200) {
                              onResult(null);

                              final success = await _authService.getSession(
                                data['session_string'],
                              );

                              if (success) {
                                final passwordSet = await _authService
                                    .setPassword(passwordController.text);
                                if (!passwordSet) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Failed to set password"),
                                    ),
                                  );
                                  return;
                                }

                                final creationSuccess = await _authService
                                    .createOrganization(
                                      email: emailController.text,
                                      name: nameController.text,
                                      country: countryController.text,
                                      description: descriptionController.text,
                                    );

                                if (creationSuccess) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Failed to create contributor',
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to restore session'),
                                  ),
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
