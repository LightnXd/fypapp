import 'package:flutter/material.dart';
import 'package:fypapp2/widget/avatar_box.dart';

import 'empty_box.dart';
import 'horizontal_box.dart';

class ProposalInfo extends StatelessWidget {
  final String orgImage;
  final double textSize;
  final Color fontColor;
  final double status;
  final double countYes;
  final double countNo;
  final double notVoted;
  final String orgName;
  final String fundAmount;
  final String title;

  const ProposalInfo({
    Key? key,
    this.orgImage = 'assets/profile_photo.jpg',
    this.textSize = 14,
    this.fontColor = Colors.black,
    this.status = 3,
    this.countYes = 40,
    this.countNo = 30,
    this.notVoted = 30,
    this.orgName = 'Organization Name',
    this.fundAmount = 'Fund amount',
    this.title = 'Fund usage title',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar + Name/Fund + Status
            AvatarBox(
              imageUrl: orgImage,
              orgName: orgName,
              desc: fundAmount,
              status: '$status status',
              textSize: textSize,
              fontColor: fontColor,
            ),
            gaph8,
            // Title
            Text(
              title,
              style: TextStyle(fontSize: textSize, color: fontColor),
            ),
            gaph8,
            // HorizontalBox
            HorizontalBox3(
              yesText: '${countYes.toInt()}% yes',
              noText: '${countNo.toInt()}% no',
              yetText: '${notVoted.toInt()}% yet',
              textSize: textSize,
              color1: Colors.teal,
              color2: Colors.deepOrange,
              color3: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}
