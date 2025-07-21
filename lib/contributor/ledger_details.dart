import 'package:flutter/material.dart';
import 'package:fypapp2/services/date_converter.dart';

import '../widget/app_bar.dart';
import '../widget/empty_box.dart';
import '../widget/icon_box.dart';

class ContributorLedgerDetailPage extends StatelessWidget {
  final String? cid;
  final String LedgerID;
  final String oid;
  final String currentHash;
  final String prevHash;
  final String transactionNumber;
  final String description;
  final String amount;
  final String creationDate;

  const ContributorLedgerDetailPage({
    super.key,
    this.cid,
    required this.LedgerID,
    required this.oid,
    required this.currentHash,
    required this.prevHash,
    required this.transactionNumber,
    required this.description,
    required this.amount,
    required this.creationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Ledger Details"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gaph32,
              horizontalIcon(
                text: 'Index:',
                extraText: transactionNumber,
                spacing: 20,
              ),
              horizontalIcon(
                text: 'LedgerID:',
                extraText: LedgerID,
                spacing: 20,
              ),
              horizontalIcon(
                text: 'Organization ID:',
                extraText: oid,
                spacing: 20,
              ),
              if (cid != null)
                horizontalIcon(
                  text: 'Contributor ID:',
                  extraText: cid,
                  spacing: 20,
                ),
              horizontalIcon(
                text: 'Hash:',
                extraText: currentHash,
                spacing: 20,
              ),
              horizontalIcon(
                text: 'Previous hash:',
                extraText: prevHash,
                spacing: 20,
              ),
              horizontalIcon(
                text: cid == null ? 'Fund used:' : 'Fund received:',
                extraText: amount,
                spacing: 20,
              ),
              horizontalIcon(
                text: 'Creation date:',
                extraText: formatDateTime(creationDate),
                spacing: 20,
              ),
              horizontalIcon(
                text: 'Description:',
                extraText: description,
                spacing: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
