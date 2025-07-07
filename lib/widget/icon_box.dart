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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: alignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imagePath != null && imagePath.isNotEmpty)
              Image.asset(imagePath, width: 45, height: 45),
            if (imagePath != null && imagePath.isNotEmpty) gapw20,
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize),
            ),
            if (extraText != null) ...[
              gapw10,
              Flexible(
                child: Text(
                  extraText,
                  style: TextStyle(color: textColor, fontSize: textSize),
                  softWrap: true,
                  overflow: TextOverflow.visible,
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
