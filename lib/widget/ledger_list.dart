import 'package:flutter/material.dart';

import '../contributor/pages/ledger_details.dart';
import 'empty_box.dart';

class LedgerList extends StatelessWidget {
  final Map<String, dynamic> entry;

  const LedgerList({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final ledgerid = entry['LedgerID'] ?? 'Unknown';
    final transactionNumber = entry['TransactionNumber'] ?? 'Unknown';
    final rowOid = entry['OID'] ?? 'Unknown';
    final cid = entry['CID'];
    final amount = entry['Amount'] == null
        ? 'Unknown'
        : entry['Amount'] == 0
        ? 'Genesis Block'
        : entry['Amount'].toString();
    final hash = entry['Hash'] ?? 'No Hash';
    final previousHash = entry['PreviousHash'] ?? 'No Previous Hash';
    final creationDate = entry['CreationDate'] ?? 'No date';

    return ListTile(
      title: Text('OID: $rowOid'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gaph2,
          Text('LedgerID: $ledgerid'),
          gaph5,
          Text('TransactionNumber: $transactionNumber'),
          gaph5,
          if (cid != null) ...[Text('CID: $cid'), gaph5],
          Text(amount == 'Genesis Block' ? 'Data: $amount' : 'Amount: $amount'),
          gaph5,
          Text('Hash: $hash'),
          gaph5,
          Text('Previous Hash: $previousHash'),
          gaph5,
          Text('Creation date: $creationDate'),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContributorLedgerDetailPage(
              oid: rowOid,
              title: cid?.toString() ?? 'Details',
            ),
          ),
        );
      },
    );
  }
}
