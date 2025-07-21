import 'package:flutter/material.dart';
import 'package:fypapp2/Organization/proposal_list.dart';
import 'package:fypapp2/Organization/transparency_test.dart';
import 'package:fypapp2/contributor/profile.dart';
import 'package:fypapp2/contributor/proposal_history.dart';
import 'package:fypapp2/contributor/verify_ledger.dart';
import 'package:fypapp2/widget/empty_box.dart';
import 'package:fypapp2/widget/icon_box.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Organization/profile.dart';
import '../Organization/proposal_history.dart';
import '../services/profile.dart';

class ContributorSideBar extends StatefulWidget {
  final String? userId;
  const ContributorSideBar({super.key, required this.userId});

  @override
  State<ContributorSideBar> createState() => _ContributorSideBarState();
}

class _ContributorSideBarState extends State<ContributorSideBar> {
  String? backgroundImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBackgroundImage();
  }

  Future<void> loadBackgroundImage() async {
    final images = await getUserImages(widget.userId!);
    final image = images?['BackgroundImage'];
    if (image != "") {
      setState(() {
        backgroundImage = image;
      });
    }
    setState(() {
      isLoading = false;
    });
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
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
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
                        spacing: 40,
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
                        imagePath: 'assets/images/verification.png',
                        text: "Verify ledger",
                        spacing: 40,
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
                        imagePath: 'assets/images/history.png',
                        text: "View proposal history",
                        spacing: 40,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ContributorProposalHistoryListPage(),
                            ),
                          );
                        },
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/log_out.png',
                        text: "Log out",
                        spacing: 40,
                        onTap: () async {
                          try {
                            await Supabase.instance.client.auth.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error signing out: $e')),
                            );
                            return;
                          }
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
  final String? userId;
  const OrganizationSideBar({super.key, required this.userId});

  @override
  State<OrganizationSideBar> createState() => _OrganizationSideBarState();
}

class _OrganizationSideBarState extends State<OrganizationSideBar> {
  String? backgroundImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBackgroundImage();
  }

  Future<void> loadBackgroundImage() async {
    final images = await getUserImages(widget.userId!);
    final image = images?['BackgroundImage'];
    if (image != "") {
      setState(() {
        backgroundImage = image;
      });
    }
    setState(() {
      isLoading = false;
    });
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
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
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
                        spacing: 40,
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
                        imagePath: 'assets/images/use_fund.png',
                        text: "Proposal list",
                        spacing: 40,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const OrganizationProposalListPage(),
                            ),
                          );
                        },
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/test.png',
                        text: "Verify Ledger",
                        spacing: 40,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerifyLedgerPage(),
                            ),
                          );
                        },
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/history.png',
                        text: "View proposal history",
                        spacing: 40,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const OrganizationProposalHistoryListPage(),
                            ),
                          );
                        },
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/test.png',
                        text: "Charity Transparency Framework Test",
                        spacing: 40,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TransparentTestPage(),
                            ),
                          );
                        },
                      ),
                      horizontalIcon(
                        imagePath: 'assets/images/log_out.png',
                        text: "Log out",
                        spacing: 40,
                        onTap: () async {
                          try {
                            await Supabase.instance.client.auth.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error signing out: $e')),
                            );
                            return;
                          }
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
