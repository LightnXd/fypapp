import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'ledger_details.dart';

class LedgerPage extends StatefulWidget {
  final String oid;

  const LedgerPage({super.key, this.oid = '111'});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  late Stream<List<Map<String, dynamic>>> _ledgerStream;

  @override
  void initState() {
    super.initState();
    _ledgerStream = Supabase.instance.client
        .from('ledger')
        .stream(primaryKey: ['LedgerID'])
        .eq('OID', widget.oid)
        .order('Index', ascending: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ledger Records')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OID: ${widget.oid}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Related ledger entries:'),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _ledgerStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SelectableText('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final entries = snapshot.data!;
                  if (entries.isEmpty) {
                    return const Text('No entries found.');
                  }

                  return ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final rowOid = entry['OID'] ?? 'Unknown';
                      final cid = entry['CID'] ?? 'Unknown';
                      final amount = entry['Amount'] ?? 'Unknown';
                      final hash = entry['Hash'] ?? 'No Hash';
                      final previousHash =
                          entry['PreviousHash'] ?? 'No Previous Hash';

                      return ListTile(
                        title: Text('OID: $rowOid'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CID: $cid'),
                            Text('Amount: $amount'),
                            Text('Hash: $hash'),
                            Text('Previous Hash: $previousHash'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LedgerDetailPage(
                                oid: rowOid,
                                title: cid.toString(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
