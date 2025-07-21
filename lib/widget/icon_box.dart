import 'package:flutter/material.dart';
import 'empty_box.dart';

Widget verticalIcon({
  String? imagePath,
  required String text,
  Color textColor = Colors.black,
  double textSize = 16.0,
  VoidCallback? onTap,
  double? spacing,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null && imagePath.isNotEmpty)
              Image.asset(imagePath, width: 45, height: 45),
            if (imagePath != null && imagePath.isNotEmpty) gaph4,
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      if (spacing != null) SizedBox(height: spacing),
    ],
  );
}

Widget horizontalIcon({
  String? imagePath,
  required String text,
  String? extraText,
  Color textColor = Colors.black,
  double textSize = 16.0,
  VoidCallback? onTap,
  double? spacing,
  MainAxisAlignment alignment = MainAxisAlignment.center,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: onTap,
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: imagePath != null && imagePath.isNotEmpty ? 8.0 : 0,
          children: [
            if (imagePath != null && imagePath.isNotEmpty)
              Image.asset(imagePath, width: 45, height: 45),

            // Constrain width so text can wrap
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200),
              child: Text(
                text,
                style: TextStyle(color: textColor, fontSize: textSize),
                softWrap: true,
              ),
            ),

            if (extraText != null) ...[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: Text(
                  extraText,
                  style: TextStyle(color: textColor, fontSize: textSize),
                  softWrap: true,
                ),
              ),
            ],
          ],
        ),
      ),
      if (spacing != null) SizedBox(height: spacing),
    ],
  );
}
