import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/proposal_list.dart';
import 'package:fypapp2/contributor/recomendation.dart';

import '../widget/navigation_bar.dart';
import 'followed_list.dart';
import 'home.dart';
import 'ledger_list.dart';

class ContributorMainPage extends StatefulWidget {
  const ContributorMainPage({super.key});

  @override
  State<ContributorMainPage> createState() => _ContributorMainPageState();
}

class _ContributorMainPageState extends State<ContributorMainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    ContributorHomePage(),
    FollowedListPage(),
    ContributorProposalListPage(),
    ContributorRecommendationPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
