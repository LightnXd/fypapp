import 'package:flutter/material.dart';
import 'package:fypapp2/widget/empty_box.dart';
import 'package:fypapp2/widget/icon_box.dart';

import '../services/profile.dart';

class ContributorSideBar extends StatefulWidget {
  final String userId;
  const ContributorSideBar({super.key, required this.userId});

  @override
  State<ContributorSideBar> createState() => _ContributorSideBarState();
}

class _ContributorSideBarState extends State<ContributorSideBar> {
  String? backgroundImage;

  @override
  void initState() {
    super.initState();
    loadBackgroundImage();
  }

  Future<void> loadBackgroundImage() async {
    final images = await getUserImages(widget.userId);
    final image = images?['BackgroundImage'];
    if (image != "") {
      setState(() {
        backgroundImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * 0.8;

    return Drawer(
      child: Container(
        width: sidebarWidth,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image
            SizedBox(
              width: double.infinity,
              height: 150,
              child: backgroundImage != null
                  ? Image.network(backgroundImage!, fit: BoxFit.cover)
                  : Image.asset('assets/images/test.webp', fit: BoxFit.cover),
            ),
            gaph16,
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      horizontalIcon(
                        imagePath: 'assets/images/test.webp',
                        text: "text",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrganizationSideBar extends StatefulWidget {
  final String userId;
  const OrganizationSideBar({super.key, required this.userId});

  @override
  State<OrganizationSideBar> createState() => _OrganizationSideBarState();
}

class _OrganizationSideBarState extends State<OrganizationSideBar> {
  String? backgroundImage;

  @override
  void initState() {
    super.initState();
    loadBackgroundImage();
  }

  Future<void> loadBackgroundImage() async {
    final images = await getUserImages(widget.userId);
    final image = images?['BackgroundImage'];
    if (image != "") {
      setState(() {
        backgroundImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * 0.8;

    return Drawer(
      child: Container(
        width: sidebarWidth,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image
            SizedBox(
              width: double.infinity,
              height: 150,
              child: backgroundImage != null
                  ? Image.network(backgroundImage!, fit: BoxFit.cover)
                  : Image.asset('assets/images/test.webp', fit: BoxFit.cover),
            ),
            gaph16,
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      horizontalIcon(
                        imagePath: 'assets/images/test.webp',
                        text: "text",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
