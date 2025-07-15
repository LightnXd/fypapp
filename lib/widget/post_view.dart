import 'package:flutter/material.dart';
import 'avatar_box.dart';
import 'dynamic_image_view.dart';
import 'empty_box.dart';

class PostView extends StatelessWidget {
  final String? profileImg;
  final String title;
  final String? desc;
  final List<String?>? imageUrls;
  final String? date;
  final VoidCallback? onAvatarTap;

  const PostView({
    Key? key,
    this.profileImg,
    required this.title,
    this.desc,
    this.imageUrls,
    this.date,
    this.onAvatarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onAvatarTap,
          child: AvatarBox(imageUrl: profileImg, imgSize: 20, orgName: title),
        ),
        gaph12,
        if (imageUrls != null && imageUrls!.isNotEmpty) ...[
          DynamicImageColumn(imageUrls: imageUrls!),
          gaph8,
        ],
        if (desc != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 20.0,
            ), // You can customize the padding
            child: SelectableText(desc!),
          ),
        if (date != null)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              date!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        gaph5,
        Divider(),
      ],
    );
  }
}
