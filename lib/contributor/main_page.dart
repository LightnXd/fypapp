import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/proposal_list.dart';
import 'package:fypapp2/contributor/recomendation.dart';

import '../widget/navigation_bar.dart';
import 'followed_list.dart';
import 'home.dart';

class ContributorMainPage extends StatefulWidget {
  const ContributorMainPage({super.key});
  @override
  State<ContributorMainPage> createState() => _ContributorMainPageState();
}

class _ContributorMainPageState extends State<ContributorMainPage> {
  int _selectedIndex = 0;
  final _homeKey = GlobalKey<ContributorHomePageState>();
  final _followedKey = GlobalKey<FollowedListPageState>();
  final _proposalKey = GlobalKey<ContributorProposalListPageState>();
  final _recomKey = GlobalKey<ContributorRecommendationPageState>();

  late final List<Widget> _pages = [
    ContributorHomePage(key: _homeKey),
    FollowedListPage(key: _followedKey),
    ContributorProposalListPage(key: _proposalKey),
    ContributorRecommendationPage(key: _recomKey),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      switch (index) {
        case 0:
          _homeKey.currentState?.refresh();
          break;
        case 1:
          _followedKey.currentState?.refresh();
          break;
        case 2:
          _proposalKey.currentState?.refresh();
          break;
        case 3:
          _recomKey.currentState?.refresh();
          break;
      }
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: ContributorNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
