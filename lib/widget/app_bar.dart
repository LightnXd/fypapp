import 'package:flutter/material.dart';

import 'empty_box.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int type; // 1 or 2 (default is 2)
  final String title;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;

  const CustomAppBar({
    super.key,
    this.type = 2,
    required this.title,
    this.onLeftPressed,
    this.onRightPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left icon (only if type 1)
            if (type == 1)
              GestureDetector(
                onTap: onLeftPressed,
                child: Image.asset(
                  'assets/images/test.webp',
                  width: 40,
                  height: 32,
                ),
              )
            else
              gapw40, // Keep spacing for alignment
            // Center title
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Right icon (always shown)
            GestureDetector(
              onTap: onRightPressed ?? () => Navigator.pop(context),
              child: Image.asset(
                'assets/images/test.webp',
                width: 40,
                height: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
