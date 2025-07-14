import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/authentication.dart';
import '../widget/app_bar.dart';
import '../widget/otp_confirmation.dart';
import '../widget/question_box.dart';
import '../widget/date_picker.dart';
import '../widget/empty_box.dart';
import '../widget/response_dialog.dart';

class ContributorRegisterPage extends StatefulWidget {
  const ContributorRegisterPage({super.key});

  @override
  State<ContributorRegisterPage> createState() =>
      _ContributorRegisterPageState();
}

class _ContributorRegisterPageState extends State<ContributorRegisterPage> {
  final AuthenticationService _authService = AuthenticationService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final confirmEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final countryController = TextEditingController();
  final birthdateController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmEmailError;
  String? confirmPasswordError;
  String? countryError;

  bool validateInputs() {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmEmail = confirmEmailController.text;
    final confirmPassword = confirmPasswordController.text;
    final confirmCountry = countryController.text;

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
      countryError = confirmCountry.isNotEmpty
          ? null
          : 'Country must not be empty';
    });

    return name.length >= 5 &&
        email.contains('@') &&
        email == confirmEmail &&
        passwordValid.hasMatch(password) &&
        password == confirmPassword &&
        confirmCountry.isNotEmpty;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    confirmEmailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    countryController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Register"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  QuestionBox(
                    image: const AssetImage(
                      'assets/images/rounded_profile.png',
                    ),
                    label: 'Name:',
                    hint: 'Enter your name',
                    controller: nameController,
                    errorText: nameError,
                  ),
                  QuestionBox(
                    image: const AssetImage('assets/images/email.png'),
                    label: 'Email:',
                    hint: 'Enter your email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: emailError,
                  ),
                  QuestionBox(
                    image: const AssetImage('assets/images/email.png'),
                    label: 'Confirm Email:',
                    hint: 'Re-enter your email',
                    controller: confirmEmailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: confirmEmailError,
                  ),
                  QuestionBox(
                    image: const AssetImage('assets/images/password.png'),
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
                    image: const AssetImage('assets/images/password.png'),
                    label: 'Confirm Password:',
                    hint: 'Re-enter your password',
                    controller: confirmPasswordController,
                    hidden: true,
                    showPassword: showConfirmPassword,
                    onTogglePassword: () => setState(
                      () => showConfirmPassword = !showConfirmPassword,
                    ),
                    errorText: confirmPasswordError,
                  ),
                  QuestionBox(
                    image: const AssetImage('assets/images/country.png'),
                    label: 'Country:',
                    hint: 'Enter your country',
                    controller: countryController,
                    errorText: countryError,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0, top: 7),
                          child: Image(
                            image: AssetImage('assets/images/birthdate.png'),
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
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
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
                          setState(() {
                            isLoading = false;
                          });
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

                                    final success = await _authService
                                        .getSession(data['session_string']);

                                    if (success) {
                                      final passwordSet = await _authService
                                          .setPassword(passwordController.text);
                                      if (!passwordSet) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (context) => ResponseDialog(
                                            title: 'Error',
                                            message: 'Failed to set password',
                                            type: false,
                                          ),
                                        );
                                        return;
                                      }

                                      final creationSuccess = await _authService
                                          .createContributor(
                                            email: emailController.text,
                                            name: nameController.text,
                                            country: countryController.text,
                                            birthdate: birthdateController.text,
                                          );

                                      if (creationSuccess) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/contributor-main',
                                        );
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (context) => ResponseDialog(
                                            title: 'Error',
                                            message:
                                                'Failed to create contributor',
                                            type: false,
                                          ),
                                        );
                                      }
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (context) => ResponseDialog(
                                          title: 'Error',
                                          message: 'Failed to restore session',
                                          type: false,
                                        ),
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    onResult(
                                      data['error'] ?? 'Verification failed',
                                    );
                                  }
                                } catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  onResult('An error occurred: $e');
                                }
                              },
                            );
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            showDialog(
                              context: context,
                              builder: (context) => ResponseDialog(
                                title: 'Error',
                                message: 'This email is already confirmed',
                                type: false,
                              ),
                            );
                          }
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (context) => ResponseDialog(
                              title: 'Error',
                              message: 'Signup error: $e',
                              type: false,
                            ),
                          );
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
