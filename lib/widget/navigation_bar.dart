import 'package:flutter/material.dart';
import 'package:fypapp2/Organization/home.dart';
import 'package:fypapp2/Organization/transaction_list.dart';
import 'package:fypapp2/contributor/pages/home.dart';
import 'package:fypapp2/contributor/pages/ledger.dart';

import 'icon_box.dart';

class ContributorNavBar extends StatefulWidget {
  final double fontSize;

  const ContributorNavBar({super.key, this.fontSize = 12});

  @override
  State<ContributorNavBar> createState() => _ContributorNavBarState();
}

class _ContributorNavBarState extends State<ContributorNavBar> {
  int selectedIndex = 0;

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
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = 0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContributorHomePage()),
              );
            },
          ),
          verticalIcon(
            imagePath: 'assets/images/search.png',
            text: 'Search',
            textColor: selectedIndex == 1 ? Colors.blue : Colors.grey,
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = 1);
            },
          ),
          verticalIcon(
            imagePath: 'assets/images/ledger.png',
            text: 'view Ledger',
            textColor: selectedIndex == 2 ? Colors.blue : Colors.grey,
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = 2);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ContributorLedgerPage(),
                ),
              );
            },
          ),
          verticalIcon(
            imagePath: 'assets/images/recommendation.png',
            text: 'Recommendation',
            textColor: selectedIndex == 3 ? Colors.blue : Colors.grey,
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = 3);
            },
          ),
          verticalIcon(
            imagePath: 'assets/images/wallet.png',
            text: 'Wallet',
            textColor: selectedIndex == 4 ? Colors.blue : Colors.grey,
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = 4);
            },
          ),
        ],
      ),
    );
  }
}

class OrganizationNavBar extends StatefulWidget {
  final double fontSize;

  const OrganizationNavBar({super.key, this.fontSize = 12});

  @override
  State<OrganizationNavBar> createState() => _OrganizationNavBarState();
}

class _OrganizationNavBarState extends State<OrganizationNavBar> {
  int selectedIndex = 0;

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
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = 0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrganizationHomePage()),
              );
            },
          ),
          verticalIcon(
            imagePath: 'assets/images/search.png',
            text: 'Search',
            textColor: selectedIndex == 1 ? Colors.blue : Colors.grey,
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = 1);
            },
          ),
          verticalIcon(
            imagePath: 'assets/images/post.png',
            text: 'Post',
            textColor: selectedIndex == 2 ? Colors.blue : Colors.grey,
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = 2);
            },
          ),
          verticalIcon(
            imagePath: 'assets/images/fund.png',
            text: 'Fund',
            textColor: selectedIndex == 3 ? Colors.blue : Colors.grey,
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = 3);
            },
          ),
          verticalIcon(
            imagePath: 'assets/images/ledger.png',
            text: 'Proposal',
            textColor: selectedIndex == 4 ? Colors.blue : Colors.grey,
            textSize: widget.fontSize,
            onTap: () {
              setState(() => selectedIndex = 4);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransactionListPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
