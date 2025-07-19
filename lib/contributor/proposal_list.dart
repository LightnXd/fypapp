import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/proposal_details.dart';
import 'package:fypapp2/widget/proposal_information.dart';
import '../services/authentication.dart';
import '../services/transaction.dart';
import '../widget/app_bar.dart';
import '../widget/empty_box.dart';
import '../widget/side_bar.dart';

class ContributorProposalListPage extends StatefulWidget {
  const ContributorProposalListPage({Key? key}) : super(key: key);

  @override
  ContributorProposalListPageState createState() =>
      ContributorProposalListPageState();
}

class ContributorProposalListPageState
    extends State<ContributorProposalListPage> {
  String? cid;
  late Future<List<Map<String, dynamic>>> _proposals;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProposals();
  }

  Future<void> refresh() async {
    setState(() => isLoading = true);
    loadProposals();
  }

  void loadProposals() async {
    try {
      final AuthenticationService authService = AuthenticationService();
      final getCID = await authService.getCurrentUserID();
      final proposals = await getActiveProposalsByFollower(getCID!);

      final proposalsWithVotes = await Future.wait(
        proposals.map((proposal) async {
          try {
            final voteStats = await getVoteStat(proposal['ProposalID']);
            return {...proposal, 'VoteStats': voteStats};
          } catch (e) {
            return {...proposal, 'VoteStats': null};
          }
        }),
      );

      setState(() {
        _proposals = Future.value(proposalsWithVotes);
        isLoading = false;
        cid = getCID;
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
      drawerEnableOpenDragGesture: false,
      drawer: ContributorSideBar(userId: cid),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: refresh,
              child: FutureBuilder<List<Map<String, dynamic>>>(
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
                      gaph16,
                      ...proposals.map((row) {
                        final voteStats = row['VoteStats'];
                        return ProposalInfo(
                          orgImage: row['Image'],
                          title: row['Title'] ?? 'No title',
                          orgName: row['Username'] ?? 'Name not found',
                          limit: '${row['Limit']} day',
                          fundAmount: row['Amount']?.toString() ?? '0',
                          countYes: voteStats?['YesVote'] ?? '0',
                          countNo: voteStats?['NoVote'] ?? '0',
                          notVoted: voteStats?['NotVoted'] ?? '0',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProposalDetailsPage(
                                  proposalid: row['ProposalID'] ?? '',
                                  oid: row['OID'] ?? '',
                                  name: row['Username'] ?? '',
                                  image: row['Image'] ?? '',
                                  title: row['Title'] ?? '',
                                  description: row['Desc'] ?? '',
                                  amount: row['Amount']?.toString() ?? '',
                                  creationDate: row['CreationDate'] ?? '',
                                  limit: '${row['Limit']} day',
                                  status: row['Status'] ?? '',
                                  cid: cid ?? '',
                                  yes: voteStats?['YesVote'] ?? '0',
                                  no: voteStats?['NoVote'] ?? '0',
                                  notVoted: voteStats?['NotVoted'] ?? '0',
                                  isHistory: false,
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
            ),
    );
  }
}
