import 'package:flutter/material.dart';

class HorizontalBox extends StatelessWidget {
  final String yesText;
  final String noText;
  final String yetText;
  final double textSize;
  final Color color1;
  final Color color2;
  final Color color3;

  const HorizontalBox({
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
        _buildBox(color1, yesText),
        _buildBox(color2, noText),
        _buildBox(color3, yetText),
      ],
    );
  }

  Widget _buildBox(Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center, // centers text within each box
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: textSize),
        textAlign: TextAlign.center,
      ),
    );
  }
}
