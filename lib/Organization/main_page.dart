import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fypapp2/Organization/follower_list.dart';

import '../widget/navigation_bar.dart';
import 'create_post.dart';
import 'create_proposal.dart';
import 'home.dart';

class OrganizationMainPage extends StatefulWidget {
  const OrganizationMainPage({super.key});

  @override
  State<OrganizationMainPage> createState() => _OrganizationMainPageState();
}

class _OrganizationMainPageState extends State<OrganizationMainPage> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    OrganizationHomePage(),
    FollowerListPage(),
    CreatePostPage(),
    CreateProposalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: _pages),
      bottomNavigationBar: OrganizationNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) => setState(() => selectedIndex = index),
      ),
    );
  }
}
