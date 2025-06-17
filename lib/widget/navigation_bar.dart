import 'package:flutter/material.dart';

import 'icon_box.dart';

class CustomNavigationBar extends StatefulWidget {
  final int navType;
  final int initialIndex;
  final ValueChanged<int>? onItemSelected;
  final double fontSize;

  const CustomNavigationBar({
    super.key,
    required this.navType,
    this.initialIndex = 0,
    this.onItemSelected,
    this.fontSize = 12,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late int selectedIndex;

  static const Map<int, List<String>> _iconPathsMap = {
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
    4: ['Home', 'Search', 'Alerts', 'Profile'],
    5: ['Home', 'Search', 'Add', 'Alerts', 'Profile'],
    6: ['Home', 'Search', 'Chat', 'Add', 'Alerts', 'Profile'],
  };

  List<String> get iconPaths => _iconPathsMap[widget.navType] ?? [];
  List<String> get labels => _labelMap[widget.navType] ?? [];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (iconPaths.length != labels.length || iconPaths.isEmpty) {
      return Container(color: Colors.red, child: Text("error occured"));
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(iconPaths.length, (index) {
          return verticalIcon(
            imagePath: iconPaths[index],
            text: labels[index],
            textColor: selectedIndex == index ? Colors.blue : Colors.grey,
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = index);
              widget.onItemSelected?.call(index);
            },
          );
        }),
      ),
    );
  }
}
