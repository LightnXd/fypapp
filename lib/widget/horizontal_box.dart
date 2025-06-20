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
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
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
    this.color1 = Colors.green,
    this.color2 = Colors.red,
    this.color3 = Colors.grey,
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

  const CustomHorizontalBox({
    super.key,
    required this.items,
    this.textSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      runAlignment: WrapAlignment.spaceAround,
      children: items
          .map(
            (text) =>
            BuildingBox(
              text: text,
              color: Colors.green,
              textSize: textSize,
            ),
      )
          .toList(),
    );
  }
}

