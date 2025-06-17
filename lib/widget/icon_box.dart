import 'package:flutter/material.dart';

import 'empty_box.dart';

Widget verticalIcon({
  required String imagePath,
  required String text,
  Color textColor = Colors.black,
  double textSize = 16.0,
  VoidCallback? onTap, // Optional tap handler
}) {
  return GestureDetector(
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
  );
}

Widget horizontalIcon({
  required String imagePath,
  required String text,
  Color textColor = Colors.black,
  double textSize = 16.0,
  VoidCallback? onTap, // Optional tap handler
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, width: 45, height: 45),
        gapw8,
        Text(
          text,
          style: TextStyle(color: textColor, fontSize: textSize),
        ),
      ],
    ),
  );
}
