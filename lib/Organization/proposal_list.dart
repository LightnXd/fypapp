import 'package:flutter/material.dart';
import 'package:fypapp2/Organization/confirm_proposal.dart';
import 'package:fypapp2/widget/proposal_information.dart';

import '../contributor/pages/ledger.dart';
import '../services/authentication.dart';
import '../services/transaction.dart';
import '../widget/app_bar.dart';
import '../widget/navigation_bar.dart';
import '../widget/side_bar.dart';

class ProposalListPage extends StatefulWidget {
  const ProposalListPage({super.key});

  @override
  State<ProposalListPage> createState() => _ProposalListPageState();
}

class _ProposalListPageState extends State<ProposalListPage> {
  String? oid;
  late Future<List<Map<String, dynamic>>> _proposals;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProposals();
  }

  void loadProposals() async {
    try {
      final AuthenticationService authService = AuthenticationService();
      final uid = authService.client.auth.currentUser!.id;
      oid = await authService.getCurrentUserID(uid);
      final proposals = getActiveProposal(oid!);

      setState(() {
        _proposals = proposals;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load proposals: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Proposal List', type: 1),
      bottomNavigationBar: OrganizationNavBar(),
      drawerEnableOpenDragGesture: false,
      drawer: oid == null ? null : OrganizationSideBar(userId: oid!),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
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
                    const SizedBox(height: 16),
                    ...proposals.map((row) {
                      return ProposalInfo(
                        orgImage: row['Image'],
                        title: row['Title'] ?? 'No title',
                        orgName: row['Username'] ?? 'Name not found',
                        limit: '${row['Limit']} day',
                        fundAmount: row['Amount']?.toString() ?? '0',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ConfirmProposalPage(
                                oid: oid!,
                                name: row['Username'] ?? '',
                                image: row['Image'] ?? '',
                                title: row['Title'] ?? '',
                                description: row['Desc'] ?? '',
                                amount: row['Amount']?.toString() ?? '',
                                creationDate: row['CreationDate'] ?? '',
                                limit: '${row['Limit']} day',
                                status: row['Status'] ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ],
                );
              },
            ),
    );
  }
}
