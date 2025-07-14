import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fypapp2/widget/checkbox.dart';
import '../../services/authentication.dart';
import '../../widget/otp_confirmation.dart';
import '../../widget/question_box.dart';
import '../../widget/empty_box.dart';
import '../widget/app_bar.dart';
import '../widget/dropdown_label.dart';
import '../widget/response_dialog.dart';

class OrganizationRegisterPage extends StatefulWidget {
  const OrganizationRegisterPage({super.key});

  @override
  State<OrganizationRegisterPage> createState() =>
      _OrganizationRegisterPageState();
}

class _OrganizationRegisterPageState extends State<OrganizationRegisterPage> {
  final AuthenticationService _authService = AuthenticationService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final confirmEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final countryController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  List<String> selectedTIDs = [];
  List<Map<String, String>> organizationTypes = [];
  bool isLoading = true;

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
  String? typeError;

  @override
  void initState() {
    super.initState();
    loadTypes();
  }

  Future<void> loadTypes() async {
    try {
      final types = await _authService.getOrganizationTypes();
      setState(() {
        organizationTypes = types;
        isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            ResponseDialog(title: 'Error', message: 'Error: $e', type: false),
      );
      setState(() => isLoading = false);
    }
  }

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
      confirmPasswordError = confirmPassword.isNotEmpty
          ? null
          : 'Confirm password must not be empty';
      countryError = confirmCountry.isNotEmpty
          ? null
          : 'Country must not be empty';
      addressError = confirmAddress.isNotEmpty
          ? null
          : 'Address must not be empty';
      descriptionError = confirmDescription.isNotEmpty
          ? null
          : 'Description must not be empty';
      typeError = selectedTIDs.isNotEmpty
          ? null
          : 'At least 1 type must be selected';
    });

    return name.length >= 5 &&
        email.contains('@') &&
        email == confirmEmail &&
        passwordValid.hasMatch(password) &&
        password == confirmPassword &&
        confirmCountry.isNotEmpty &&
        confirmAddress.isNotEmpty &&
        confirmDescription.isNotEmpty &&
        selectedTIDs.isNotEmpty;
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
      appBar: CustomAppBar(title: 'Organization Registration'),
      body: isLoading
          ? const CircularProgressIndicator()
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
                    image: const AssetImage('assets/images/test.png'),
                    label: 'Confirm Email:',
                    hint: 'Re-enter your email',
                    controller: confirmEmailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: confirmEmailError,
                  ),
                  QuestionBox(
                    image: const AssetImage('assets/images/test.png'),
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
                    image: const AssetImage('assets/images/test.png'),
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
                  gaph4,
                  DropdownLabel(
                    label: "Select Types",
                    imagePath: 'assets/images/sdg.png',
                    textColor: Colors.black,
                    errorText: typeError,
                    onPressed: () {
                      showCheckboxDialog(context);
                    },
                  ),
                  gaph4,
                  QuestionBox(
                    image: const AssetImage('assets/images/address.png'),
                    label: 'Address:',
                    hint: 'Enter your address',
                    controller: addressController,
                    errorText: addressError,
                  ),
                  QuestionBox(
                    image: const AssetImage('assets/images/country.png'),
                    label: 'Country:',
                    hint: 'Enter your country',
                    controller: countryController,
                    errorText: countryError,
                  ),
                  QuestionBox(
                    label: 'Description:',
                    hint: 'Description',
                    maxline: 10,
                    controller: descriptionController,
                    errorText: descriptionError,
                  ),
                  gaph28,
                  ElevatedButton(
                    onPressed: () async {
                      handleRegisterPressed();
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
            ),
    );
  }

  void showCheckboxDialog(BuildContext context) {
    List<String> tempSelected = List.from(selectedTIDs);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Select Organization Types"),
        content: SingleChildScrollView(
          child: CustomCheckbox(
            types: organizationTypes,
            initialSelectedTIDs: tempSelected,
            onSelectionChanged: (selected) {
              tempSelected = selected;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => selectedTIDs = tempSelected);
              Navigator.pop(context);
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Future<void> handleRegisterPressed() async {
    if (!validateInputs()) return;

    try {
      setState(() {
        isLoading = true;
      });
      final shouldVerify = await _authService.signUp(emailController.text);
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
                  final passwordSet = await _authService.setPassword(
                    passwordController.text,
                  );
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

                  final creationSuccess = await _authService.createOrganization(
                    email: emailController.text,
                    name: nameController.text,
                    country: countryController.text,
                    description: descriptionController.text,
                    address: addressController.text,
                    type: selectedTIDs,
                  );

                  if (creationSuccess) {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushReplacementNamed(
                      context,
                      '/organization-main',
                    );
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                      context: context,
                      builder: (context) => ResponseDialog(
                        title: 'Error',
                        message: 'Failed to create Organization',
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
                onResult(data['error'] ?? 'Verification failed');
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
}
