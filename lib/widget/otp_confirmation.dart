import 'package:flutter/material.dart';

class OtpDialog extends StatefulWidget {
  final void Function(String otp, void Function(String? error) onResult) onSubmitted;

  const OtpDialog({super.key, required this.onSubmitted});

  static Future<void> show({
    required BuildContext context,
    required void Function(String otp, void Function(String? error) onResult) onSubmitted,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        child: OtpDialog(onSubmitted: onSubmitted),
      ),
    );
  }

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  final TextEditingController _otpController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  void _submitOtp() {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      setState(() => _errorText = "Please enter the OTP");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    widget.onSubmitted(otp, (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorText = error;
        });

        if (error == null) {
          Navigator.of(context).pop(); // Success
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter OTP'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'OTP Code',
              border: const OutlineInputBorder(),
              errorText: _errorText,
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitOtp,
          child: const Text('Verify'),
        ),
      ],
    );
  }
}
