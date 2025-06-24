import 'package:flutter/material.dart';
import 'package:fypapp2/Organization/confirm_transaction.dart';
import 'package:fypapp2/Organization/transaction_list.dart';
import 'package:fypapp2/contributor/pages/profile.dart';
import 'package:fypapp2/contributor/pages/verify_ledger.dart';
import 'package:fypapp2/widget/empty_box.dart';
import 'package:fypapp2/widget/icon_box.dart';

import '../Organization/profile.dart';
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
                  : Image.asset(
                      'assets/images/side_background.jpg',
                      fit: BoxFit.cover,
                    ),
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
                        imagePath: 'assets/images/border_profile.png',
                        text: "Profile",
                        spacing: 32,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ContributorProfilePage(),
                            ),
                          );
                        },
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/follower.png',
                        text: "Following list",
                        spacing: 32,
                        onTap: () {},
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/top_up.png',
                        text: "Top up wallet",
                        spacing: 32,
                        onTap: () {},
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/donate.png',
                        text: "Donate",
                        spacing: 32,
                        onTap: () {},
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/verification.png',
                        text: "Verify ledger",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VerifyLedgerPage(),
                            ),
                          );
                        },
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/log_out.png',
                        text: "Log out",
                        spacing: 32,
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
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
    final sidebarWidth = screenWidth * 0.9;

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
                  : Image.asset(
                      'assets/images/side_background.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
            gaph32,
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      horizontalIcon(
                        imagePath: 'assets/images/border_profile.png',
                        text: "Profile",
                        spacing: 32,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OrganizationProfilePage(),
                            ),
                          );
                        },
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/follower.png',
                        text: "Follower list",
                        spacing: 32,
                        onTap: () {},
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/use_fund.png',
                        text: "Use fund",
                        spacing: 32,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConfirmTransactionPage(),
                            ),
                          );
                        },
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/ledger.png',
                        text: "View transaction list",
                        spacing: 32,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TransactionListPage(),
                            ),
                          );
                        },
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/test.png',
                        text: "Charity framework test",
                        spacing: 32,
                        onTap: () {},
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/log_out.png',
                        text: "Log out",
                        spacing: 32,
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
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
