import 'package:flutter/material.dart';

class BuildingBox extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final double? width;
  final VoidCallback? onTap;

  const BuildingBox({
    super.key,
    required this.text,
    this.color = const Color(0xFFBAFFC9),
    this.textSize = 10,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.only(right: 15, bottom: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: textSize),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class HorizontalBox3 extends StatelessWidget {
  final String leftText;
  final String midText;
  final String rightText;
  final double textSize;
  final Color color1;
  final Color color2;
  final Color color3;
  final double? width;

  final VoidCallback? onLeftTap;
  final VoidCallback? onMidTap;
  final VoidCallback? onRightTap;

  const HorizontalBox3({
    super.key,
    required this.leftText,
    required this.midText,
    required this.rightText,
    this.textSize = 10,
    this.color1 = const Color(0xFFBAFFC9),
    this.color2 = const Color(0xFFFF8A8A),
    this.color3 = const Color(0xFFE9E9E9),
    this.width,
    this.onLeftTap,
    this.onMidTap,
    this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BuildingBox(
          text: leftText,
          color: color1,
          textSize: textSize,
          width: width,
          onTap: onLeftTap,
        ),
        BuildingBox(
          text: midText,
          color: color2,
          textSize: textSize,
          width: width,
          onTap: onMidTap,
        ),
        BuildingBox(
          text: rightText,
          color: color3,
          textSize: textSize,
          width: width,
          onTap: onRightTap,
        ),
      ],
    );
  }
}

class CustomHorizontalBox extends StatelessWidget {
  final List<String> items;
  final double textSize;
  final Color color;

  const CustomHorizontalBox({
    super.key,
    required this.items,
    this.textSize = 14.0,
    this.color = const Color(0xFFBAFFC9),
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: items
          .map(
            (text) => BuildingBox(text: text, color: color, textSize: textSize),
          )
          .toList(),
    );
  }
}
