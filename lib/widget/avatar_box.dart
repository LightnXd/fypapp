import 'package:flutter/material.dart';

import 'empty_box.dart';

class AvatarBox extends StatelessWidget {
  final String imageUrl;
  final String orgName;
  final String? desc;
  final String? status;
  final double textSize;
  final Color fontColor;

  const AvatarBox({
    super.key,
    required this.imageUrl,
    required this.orgName,
    this.desc,
    required this.status,
    this.textSize = 12,
    this.fontColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile image
        CircleAvatar(
          radius: 30,
          backgroundImage: (imageUrl.isNotEmpty && imageUrl.startsWith('http'))
              ? NetworkImage(imageUrl)
              : const AssetImage('assets/profile_photo.jpg') as ImageProvider,
        ),
        gapw10,
        // Name and fund amount
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
        if (status != null)
          Text(
            status!,
            style: TextStyle(fontSize: textSize, color: fontColor),
          ),
      ],
    );
  }
}
