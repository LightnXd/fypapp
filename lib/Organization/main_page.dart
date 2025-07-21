import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fypapp2/Organization/follower_list.dart';
import 'package:fypapp2/Organization/proposal_list.dart';

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

  final _homeKey = GlobalKey<OrganizationHomePageState>();
  final _followersKey = GlobalKey<FollowerListPageState>();

  late final List<Widget> _tabs = [
    OrganizationHomePage(key: _homeKey),
    FollowerListPage(key: _followersKey),
    CreatePostPage(),
    CreateProposalPage(),
  ];

  void _onNavTapped(int index) {
    if (index == selectedIndex) {
      if (index == 0)
        _homeKey.currentState?.refresh();
      else if (index == 1)
        _followersKey.currentState?.refresh();
    } else {
      setState(() => selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: _tabs),
      bottomNavigationBar: OrganizationNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onNavTapped,
      ),
    );
  }
}
