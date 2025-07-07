import 'package:flutter/material.dart';
import 'empty_box.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int type;
  final String title;

  const CustomAppBar({super.key, this.type = 2, required this.title});

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
          children: [
            GestureDetector(
              onTap: () {
                if (type == 1) {
                  Scaffold.of(context).openDrawer();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Image.asset(
                type == 1 ? 'assets/images/menu.png' : 'assets/images/back.png',
                width: 40,
                height: 32,
              ),
            ),
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
            gapw40,
          ],
        ),
      ),
    );
  }
}
