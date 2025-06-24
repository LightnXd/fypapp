import 'package:flutter/material.dart';

class BuildingBox extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;

  const BuildingBox({
    super.key,
    required this.text,
    required this.color,
    this.textSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(right: 15, bottom: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      // Don't set constraints or width here
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: textSize),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class HorizontalBox3 extends StatelessWidget {
  final String yesText;
  final String noText;
  final String yetText;
  final double textSize;
  final Color color1;
  final Color color2;
  final Color color3;

  const HorizontalBox3({
    super.key,
    this.yesText = 'vote yes',
    this.noText = 'vote no',
    this.yetText = 'yet to vote',
    this.textSize = 10,
    this.color1 = const Color(0xFFBAFFC9),
    this.color2 = const Color(0xFFFF8A8A),
    this.color3 = const Color(0xFFE9E9E9),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BuildingBox(text: yesText, color: color1, textSize: textSize),
        BuildingBox(text: noText, color: color2, textSize: textSize),
        BuildingBox(text: yetText, color: color3, textSize: textSize),
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
