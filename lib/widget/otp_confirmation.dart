import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'empty_box.dart';

class OtpDialog extends StatefulWidget {
  final void Function(String otp, void Function(String? error) onResult) onSubmitted;

  const OtpDialog({super.key, required this.onSubmitted});

  static Future<void> show({
    required BuildContext context,
    required void Function(String otp, void Function(String? error) onResult) onSubmitted,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // So it can grow based on content or keyboard
      backgroundColor: Colors.transparent, // Remove default white background
      builder: (_) => OtpDialog(onSubmitted: onSubmitted),
    );
  }

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  String _otp = '';
  String? _errorText;
  bool _isLoading = false;

  void _submitOtp() {
    if (_otp.length < 6) {
      setState(() => _errorText = "Enter all 6 digits");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    widget.onSubmitted(_otp, (error) {
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          child: Container(
            width: screenWidth * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(width: 0.6, color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter OTP',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                gaph16,
                PinCodeTextField(

                  appContext: context,
                  length: 6,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  onChanged: (value) {
                    _otp = value;
                  },
                  onCompleted: (value) {
                    _otp = value;
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    activeColor: Colors.black,
                    inactiveColor: Colors.grey,
                    selectedColor: Colors.blue ,
                    borderRadius: BorderRadius.circular(6),
                    fieldHeight: screenWidth * 0.13,
                    fieldWidth: screenWidth * 0.1,
                    activeFillColor: Colors.white,
                  ),
                ),
                if (_errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _errorText!,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: CircularProgressIndicator(),
                  ),
                gaph10,
                Flexible(
                  child: Text(
                    'Enter a 6 digit OTP from your email',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                gaph24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitOtp,
                      child: const Text('Submit'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                gaph10,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
