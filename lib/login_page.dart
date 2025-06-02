import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/pages/register.dart';
import 'package:fypapp2/widget/empty_box.dart';
import 'package:fypapp2/widget/question_box.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  String? emailError;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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
              const QuestionBox(
                label: 'Password',
                hint: 'Enter your password',
              ),
              gaph28,
              ElevatedButton(
                onPressed: () {
                  // Add login logic here

                setState(() {
                  final email = emailController.text;
                  emailError = email.contains('@') ? null : 'Invalid email address';
                });
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
            ],
          ),
        ),
      ),
    );
  }
}

