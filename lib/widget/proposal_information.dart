import 'package:flutter/material.dart';
import 'package:fypapp2/widget/avatar_box.dart';

import 'empty_box.dart';
import 'horizontal_box.dart';

class ProposalInfo extends StatelessWidget {
  final String? orgImage;
  final double textSize;
  final Color fontColor;
  final String limit;
  final double countYes;
  final double countNo;
  final double notVoted;
  final String orgName;
  final String fundAmount;
  final String title;
  final VoidCallback? onTap; // <-- Add this

  const ProposalInfo({
    Key? key,
    this.orgImage,
    this.textSize = 14,
    this.fontColor = Colors.black,
    this.limit = "-1 days",
    this.countYes = 40,
    this.countNo = 30,
    this.notVoted = 30,
    this.orgName = 'Organization Name',
    this.fundAmount = 'Fund amount',
    this.title = 'Fund usage title',
    this.onTap, // <-- Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // <-- Wrap with InkWell
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarBox(
                imageUrl: orgImage,
                orgName: orgName,
                desc: fundAmount,
                limit: limit,
                textSize: textSize,
                fontColor: fontColor,
              ),
              gaph8,
              Text(
                title,
                style: TextStyle(fontSize: textSize, color: fontColor),
              ),
              gaph8,
              HorizontalBox3(
                yesText: '${countYes.toInt()}% yes',
                noText: '${countNo.toInt()}% no',
                yetText: '${notVoted.toInt()}% yet',
                textSize: textSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
