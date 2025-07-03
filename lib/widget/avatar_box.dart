import 'package:flutter/material.dart';

import 'empty_box.dart';

class AvatarBox extends StatelessWidget {
  final String? imageUrl;
  final String orgName;
  final String? desc;
  final String? limit;
  final double textSize;
  final Color fontColor;

  const AvatarBox({
    super.key,
    this.imageUrl,
    required this.orgName,
    this.desc,
    required this.limit,
    this.textSize = 12,
    this.fontColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage:
              (imageUrl != null &&
                  imageUrl!.isNotEmpty &&
                  imageUrl!.startsWith('http'))
              ? NetworkImage(imageUrl!)
              : const AssetImage('assets/images/profile.png') as ImageProvider,
        ),
        gapw12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orgName,
                style: TextStyle(
                  fontSize: textSize + 2,
                  fontWeight: FontWeight.bold,
                  color: fontColor,
                ),
              ),
              gaph8,
              if (desc != null)
                Text(
                  desc!,
                  style: TextStyle(fontSize: textSize, color: fontColor),
                ),
            ],
          ),
        ),
        if (limit != null)
          Text(
            limit!,
            style: TextStyle(fontSize: textSize, color: fontColor),
          ),
      ],
    );
  }
}
