import 'package:flutter/material.dart';

class ContributorLedgerDetailPage extends StatelessWidget {
  final String oid;
  final String title;

  const ContributorLedgerDetailPage({super.key, required this.oid, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Details for Ledger Entry:\nOID: $oid'),
      ),
    );
  }
}
