import 'package:flutter/material.dart';

class QuestionBox extends StatelessWidget {
  final String label;
  final double labelWidth;
  final double fontSize;
  final Color textColor;
  final Color borderColor;
  final TextInputType keyboardType;
  final String hint;
  final bool hidden;
  final TextEditingController? controller;
  final String? errorText;
  final bool showPassword;
  final VoidCallback? onTogglePassword;
  final ImageProvider? image;

  const QuestionBox({
    super.key,
    required this.label,
    this.labelWidth = 100.0,
    this.fontSize = 14.0,
    this.textColor = Colors.black,
    this.borderColor = Colors.grey,
    this.keyboardType = TextInputType.text,
    required this.hint,
    this.hidden = false,
    this.controller,
    this.errorText,
    this.showPassword = false,
    this.onTogglePassword,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 7),
              child: Image(
                image: image!,
                width: 40,
                height: 40,
              ),
            ),
          SizedBox(
            width: labelWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      hintStyle: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    obscureText: hidden && !showPassword,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      suffixIcon: hidden
                          ? IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: onTogglePassword,
                      )
                          : null,
                    ),
                  ),
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 4.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorText!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: fontSize - 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
