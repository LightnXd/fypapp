import 'package:flutter/material.dart';

import 'empty_box.dart';

class AvatarBox extends StatelessWidget {
  final String? imageUrl;
  final double imgSize;
  final String orgName;
  final String? desc;
  final String? limit;
  final double textSize;
  final Color fontColor;

  const AvatarBox({
    super.key,
    this.imageUrl,
    this.imgSize = 30,
    required this.orgName,
    this.desc,
    this.limit,
    this.textSize = 12,
    this.fontColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: imgSize,
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
                  fontSize: textSize + 4,
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
