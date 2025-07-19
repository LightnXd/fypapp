import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fypapp2/services/authentication.dart';
import 'package:fypapp2/widget/otp_confirmation.dart';
import 'package:fypapp2/widget/question_box.dart';
import 'package:fypapp2/widget/response_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _emailError, _passwordError, _confirmError;
  bool _showPassword = false, _showConfirm = false, _isLoading = false;

  final _authService = AuthenticationService();

  bool _validateFields() {
    final email = _emailController.text.trim();
    final pwd = _passwordController.text;
    final conf = _confirmController.text;

    final pwdRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,24}$',
    );

    final emailValid = email.contains('@');
    final pwdValid = pwdRegex.hasMatch(pwd);
    final matchValid = pwd == conf;

    setState(() {
      _emailError = emailValid ? null : 'Invalid email address';
      _passwordError = pwdValid
          ? null
          : '8–24 chars, upper/lower/number/symbol';
      _confirmError = matchValid ? null : 'Passwords do not match';
    });

    return emailValid && pwdValid && matchValid;
  }

  Future<void> _onResetPressed() async {
    if (!_validateFields()) return;

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final newPassword = _passwordController.text;

    try {
      await _authService.sendOTP(email);
    } catch (e) {
      setState(() => _isLoading = false);
      return showDialog(
        context: context,
        builder: (_) => const ResponseDialog(
          title: 'Error',
          message: 'Failed to send OTP',
          type: false,
        ),
      );
    }
    await OtpDialog.show(
      context: context,
      onSubmitted: (otp, onResult) async {
        try {
          final response = await _authService.verifyOTP(email: email, otp: otp);
          final data = jsonDecode(response.body);
          if (response.statusCode != 200) {
            setState(() => _isLoading = false);
            return onResult(data['error'] ?? 'OTP verification failed');
          }
          onResult(null);
          final sessionOk = await _authService.getSession(
            data['session_string'],
          );
          if (!sessionOk) {
            setState(() => _isLoading = false);
            return showDialog(
              context: context,
              builder: (_) => const ResponseDialog(
                title: 'Error',
                message: 'Failed to restore session',
                type: false,
              ),
            );
          }
          final pwdSet = await _authService.setPassword(newPassword);
          setState(() => _isLoading = false);

          if (!pwdSet) {
            return showDialog(
              context: context,
              builder: (_) => const ResponseDialog(
                title: 'Error',
                message: 'Failed to reset password',
                type: false,
              ),
            );
          }
          await showDialog(
            context: context,
            builder: (_) => const ResponseDialog(
              title: 'Success',
              message: 'Your password has been reset.',
              type: true,
            ),
          );
          await Supabase.instance.client.auth.signOut();
          Navigator.pop(context);
        } catch (e) {
          setState(() => _isLoading = false);
          onResult('An error occurred: $e');
        }
      },
    ).then((_) {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    QuestionBox(
                      image: const AssetImage('assets/images/test.png'),
                      label: 'Email:',
                      hint: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                    ),
                    const SizedBox(height: 20),
                    QuestionBox(
                      image: const AssetImage('assets/images/test.png'),
                      label: 'New Password:',
                      hint: 'Enter new password',
                      controller: _passwordController,
                      hidden: true,
                      showPassword: _showPassword,
                      onTogglePassword: () =>
                          setState(() => _showPassword = !_showPassword),
                      errorText: _passwordError,
                    ),
                    const SizedBox(height: 20),
                    QuestionBox(
                      image: const AssetImage('assets/images/test.png'),
                      label: 'Confirm Password:',
                      hint: 'Re-enter new password',
                      controller: _confirmController,
                      hidden: true,
                      showPassword: _showConfirm,
                      onTogglePassword: () =>
                          setState(() => _showConfirm = !_showConfirm),
                      errorText: _confirmError,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _onResetPressed,
                      child: const Text('Send Reset OTP'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
