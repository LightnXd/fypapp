import 'package:flutter/material.dart';
import 'package:fypapp2/Organization/create_post.dart';
import 'package:fypapp2/Organization/create_proposal.dart';
import 'package:fypapp2/Organization/home.dart';
import 'package:fypapp2/Organization/proposal_list.dart';
import 'package:fypapp2/contributor/home.dart';
import 'package:fypapp2/contributor/ledger_list.dart';

import 'icon_box.dart';

class ContributorNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final double fontSize;

  const ContributorNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          verticalIcon(
            imagePath: 'assets/images/home.png',
            text: 'Home',
            textColor: selectedIndex == 0 ? Colors.blue : Colors.grey,
            textSize: fontSize,
            onTap: () => onItemTapped(0),
          ),
          verticalIcon(
            imagePath: 'assets/images/search.png',
            text: 'Followed Account',
            textColor: selectedIndex == 1 ? Colors.blue : Colors.grey,
            textSize: fontSize,
            onTap: () => onItemTapped(1),
          ),
          verticalIcon(
            imagePath: 'assets/images/ledger.png',
            text: 'View Proposal',
            textColor: selectedIndex == 2 ? Colors.blue : Colors.grey,
            textSize: fontSize,
            onTap: () => onItemTapped(2),
          ),
          verticalIcon(
            imagePath: 'assets/images/recommendation.png',
            text: 'Recommendation',
            textColor: selectedIndex == 3 ? Colors.blue : Colors.grey,
            textSize: fontSize,
            onTap: () => onItemTapped(3),
          ),
        ],
      ),
    );
  }
}

class OrganizationNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final double fontSize;

  const OrganizationNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          verticalIcon(
            imagePath: 'assets/images/home.png',
            text: 'Home',
            textColor: selectedIndex == 0 ? Colors.blue : Colors.grey,
            textSize: fontSize,
            onTap: () => onItemTapped(0),
          ),
          verticalIcon(
            imagePath: 'assets/images/search.png',
            text: 'View Follower',
            textColor: selectedIndex == 1 ? Colors.blue : Colors.grey,
            textSize: fontSize,
            onTap: () => onItemTapped(1),
          ),
          verticalIcon(
            imagePath: 'assets/images/post.png',
            text: 'Post',
            textColor: selectedIndex == 2 ? Colors.blue : Colors.grey,
            textSize: fontSize,
            onTap: () => onItemTapped(2),
          ),
          verticalIcon(
            imagePath: 'assets/images/ledger.png',
            text: 'Create Proposal',
            textColor: selectedIndex == 4 ? Colors.blue : Colors.grey,
            textSize: fontSize,
            onTap: () => onItemTapped(4),
          ),
        ],
      ),
    );
  }
}
