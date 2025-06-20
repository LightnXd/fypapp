import 'package:flutter/material.dart';
import 'empty_box.dart';
import 'icon_box.dart';

class CustomSideBar extends StatelessWidget {
  final int navType; // number of icons (3, 4, 5)
  final double fontSize;
  final double iconSpacing;

  const CustomSideBar({
    super.key,
    required this.navType,
    this.fontSize = 14,
    this.iconSpacing = 16,
  });

  static const Map<int, List<String>> _iconPathsMap = {
    3: [
      'assets/images/test.webp',
      'assets/images/test.webp',
      'assets/images/test.webp',
    ],
    4: [
      'assets/images/test.webp',
      'assets/images/test.webp',
      'assets/images/test.webp',
      'assets/images/test.webp',
    ],
    5: [
      'assets/images/test.webp',
      'assets/images/test.webp',
      'assets/images/test.webp',
      'assets/images/test.webp',
      'assets/images/test.webp',
    ],
  };

  static const Map<int, List<String>> _labelMap = {
    3: ['Home', 'Search', 'Profile'],
    4: ['Home', 'Search', 'Alerts', 'Profile'],
    5: ['Home', 'Search', 'Chat', 'Alerts', 'Profile'],
  };

  @override
  Widget build(BuildContext context) {
    final iconPaths = _iconPathsMap[navType] ?? [];
    final labels = _labelMap[navType] ?? [];

    if (iconPaths.length != labels.length || iconPaths.isEmpty) {
      return Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: const Text('Error: Invalid navType'),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * 0.8;

    return Container(
      width: sidebarWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top image (remains fixed)
          SizedBox(
            width: double.infinity,
            child: Image.asset('assets/images/test.webp', fit: BoxFit.cover),
          ),
          gaph20,
          // Scrollable icon list
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(iconPaths.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: iconSpacing,
                      left: 20,
                      right: 20,
                    ),
                    child: horizontalIcon(
                      imagePath: iconPaths[index],
                      text: labels[index],
                      textSize: fontSize,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
