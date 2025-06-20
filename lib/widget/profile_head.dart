import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String? profileUrl;
  final String? backgroundUrl;
  final String follower = "0";

  const ProfileHeader({super.key, this.profileUrl, this.backgroundUrl});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double profileRadius = screenWidth / 5.5;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        (backgroundUrl != null && backgroundUrl!.isNotEmpty)
            ? Image.network(
                backgroundUrl!,
                height: screenHeight / 3.1,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/images/test.webp',
                height: screenHeight / 3.1,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

        // Profile image + followings
        Positioned(
          bottom: -profileRadius,
          left: 0,
          right: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: screenWidth / 13.6),
                child: CircleAvatar(
                  radius: profileRadius,
                  backgroundImage:
                      (profileUrl != null && profileUrl!.isNotEmpty)
                      ? NetworkImage(profileUrl!)
                      : const AssetImage('assets/images/test.webp'),
                  child: (profileUrl == null || profileUrl!.isEmpty)
                      ? const Text(
                          'Profile image',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      : null,
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  right: screenWidth / 20,
                  top: profileRadius * 1.2,
                ),
                child: Text(
                  '$follower Followings',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
