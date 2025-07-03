import 'package:flutter/material.dart';

import '../widget/app_bar.dart';

class ContributorLedgerDetailPage extends StatelessWidget {
  final String oid;
  final String title;

  const ContributorLedgerDetailPage({
    super.key,
    required this.oid,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Ledger Details"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("add something if ledger list not enough")],
        ),
      ),
    );
  }
}
