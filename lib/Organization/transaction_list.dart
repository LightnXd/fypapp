import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fypapp2/widget/proposal_information.dart';

import '../contributor/pages/ledger.dart';
import '../widget/app_bar.dart';
import '../widget/empty_box.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final String oid = 'id111';
  late Future<List<Map<String, dynamic>>> _proposals;

  @override
  void initState() {
    super.initState();
    _proposals = fetchProposals();
  }

  Future<List<Map<String, dynamic>>> fetchProposals() async {
    final response = await Supabase.instance.client
        .from('proposal')
        .select()
        .eq('OID', oid);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Transaction List', type: 2),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _proposals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('No proposals found.'));
          }

          final proposals = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text('Proposal info list', style: TextStyle(fontSize: 16)),
              gaph16,
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ContributorLedgerPage(),
                    ),
                  );
                },
                child: const Text('Switch Page'),
              ),
              const SizedBox(height: 16),
              ...proposals.map((row) {
                return ProposalInfo(
                  title: row['Title'] ?? 'No title',
                  orgName: oid,
                  fundAmount: row['Amount']?.toString() ?? '0',
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
