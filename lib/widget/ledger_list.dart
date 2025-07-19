import 'package:flutter/material.dart';

import '../contributor/ledger_details.dart';
import '../services/date_converter.dart';
import 'empty_box.dart';

class LedgerList extends StatelessWidget {
  final Map<String, dynamic> entry;

  const LedgerList({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final ledgerID = entry['LedgerID'] ?? 'Unknown';
    final transactionNumber = entry['TransactionNumber'] ?? 'Unknown';
    final rowOid = entry['OID'] ?? 'Unknown';
    final cid = entry['CID'];
    final amount = entry['Amount'].toString();
    final hash = entry['Hash'] ?? 'No Hash';
    final previousHash = entry['PreviousHash'] ?? 'No Previous Hash';
    final creationDate = entry['CreationDate'] ?? 'No date';
    final description = entry['Description'] ?? 'No description';

    return ListTile(
      title: Text('Ledger Number: $transactionNumber'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gaph2,
          Text('LedgerID: $ledgerID'),
          gaph5,
          Text('Amount: $amount'),
          Align(
            alignment: Alignment.centerRight,
            child: Text(formatDate(creationDate)),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContributorLedgerDetailPage(
              oid: rowOid,
              transactionNumber: transactionNumber.toString(),
              LedgerID: ledgerID,
              currentHash: hash,
              prevHash: previousHash,
              description: description,
              amount: amount,
              creationDate: creationDate,
              cid: cid,
            ),
          ),
        );
      },
    );
  }
}
