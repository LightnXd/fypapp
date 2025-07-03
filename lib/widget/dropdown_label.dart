import 'package:flutter/material.dart';

class DropdownLabel extends StatelessWidget {
  final String label;
  final String? buttonText;
  final double textSize;
  final Color textColor;
  final double iconSize;
  final String? imagePath;
  final VoidCallback onPressed;
  final String? errorText;

  const DropdownLabel({
    super.key,
    required this.label,
    this.textSize = 16.0,
    this.textColor = Colors.black,
    this.iconSize = 30,
    this.imagePath,
    this.buttonText,
    this.onPressed = _defaultOnPressed,
    this.errorText,
  });

  static void _defaultOnPressed() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (imagePath != null && imagePath!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(imagePath!, width: 40, height: 40),
              ),
            SizedBox(
              width: 100,
              child: Text(
                "$label:",
                style: TextStyle(fontSize: textSize, color: textColor),
              ),
            ),
            Expanded(
              child: OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.only(left: 30),
                  textStyle: TextStyle(fontSize: textSize),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      buttonText ?? label,
                      style: TextStyle(color: textColor),
                    ),
                    Icon(Icons.keyboard_arrow_down, size: iconSize),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(
              left: (imagePath != null && imagePath!.isNotEmpty)
                  ? 158.0
                  : 108.0,
              top: 4.0,
            ),
            child: Text(
              errorText!,
              style: TextStyle(color: Colors.red, fontSize: textSize - 2),
            ),
          ),
      ],
    );
  }
}
