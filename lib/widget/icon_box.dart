import 'package:flutter/material.dart';

import 'empty_box.dart';

Widget verticalIcon({
  required String imagePath,
  required String text,
  Color textColor = Colors.black,
  double textSize = 16.0,
  VoidCallback? onTap,
  double? spacing, // optional spacing box after this widget
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, width: 45, height: 45),
            gaph4,
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize),
            ),
          ],
        ),
      ),
      if (spacing != null) SizedBox(height: spacing),
    ],
  );
}

Widget horizontalIcon({
  required String imagePath,
  required String text,
  Color textColor = Colors.black,
  double textSize = 16.0,
  VoidCallback? onTap,
  double? spacing, // optional spacing box after this widget
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, width: 45, height: 45),
            gapw20,
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize),
            ),
          ],
        ),
      ),
      if (spacing != null) SizedBox(height: spacing),
    ],
  );
}
