import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/profile.dart';
import 'package:fypapp2/widget/app_bar.dart';
import 'package:fypapp2/widget/navigation_bar.dart';
import 'package:fypapp2/widget/side_bar.dart';

import '../services/authentication.dart';
import '../services/date_converter.dart';
import '../services/posting.dart';
import '../services/profile.dart';
import '../widget/avatar_box.dart';
import '../widget/empty_box.dart';
import '../widget/post_view.dart';
import '../widget/response_dialog.dart';
import 'organization_details.dart';

class ContributorHomePage extends StatefulWidget {
  const ContributorHomePage({super.key});

  @override
  State<ContributorHomePage> createState() => _ContributorHomePageState();
}

class _ContributorHomePageState extends State<ContributorHomePage> {
  final AuthenticationService _authService = AuthenticationService();
  String cid = '';
  String status = '';
  bool isLoading = true;
  List<Map<String, dynamic>> _originalList = [];
  List<Map<String, dynamic>> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isPostLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
    fetchPosts();
  }

  void loadUserData() async {
    final user = _authService.client.auth.currentUser;
    if (user != null) {
      try {
        final fetchedCid = await _authService.getCurrentUserID();
        final userStatus = await getUserStatus(fetchedCid!);
        setState(() {
          cid = fetchedCid;
          status = userStatus!;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = true;
        });
        showDialog(
          context: context,
          builder: (context) => ResponseDialog(
            title: 'Unexpected Error',
            message: 'Failed to fetch user data: $e',
            type: false,
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => ResponseDialog(
          title: 'User not found',
          message: 'Unable to get user\'s information',
          type: false,
        ),
      );
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<void> fetchPosts() async {
    final posts = await getAllFollowedPost(cid);
    setState(() {
      _originalList = posts;
      _filteredList = posts;
      _isPostLoading = false;
    });
  }

  void _filterList(String query) {
    setState(() {
      _filteredList = _originalList
          .where(
            (post) =>
                (post['Tittle'] ?? '').toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                (post['Description'] ?? '').toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Home", type: 1),
      drawerEnableOpenDragGesture: false,
      drawer: ContributorSideBar(userId: cid),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : status != 'Active'
          ? const Center(child: Text('Your account have been suspended'))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ResponseDialog(
                            title: 'Transaction Successful',
                            message:
                                'Transaction saved to the ledger with LedgerID:',
                            type: false,
                          ),
                        );
                      },
                      child: const Text('Go to Profile'),
                    ),
                  ),
                  gaph32,
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search posts...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: _filterList,
                  ),
                  gaph32,
                  _isPostLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredList.isEmpty
                      ? const Center(child: Text('No post found.'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredList.length,
                          itemBuilder: (context, index) {
                            final post = _filteredList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: PostView(
                                profileImg: post['ProfileImage'],
                                title: post['Tittle'] ?? 'No Title',
                                desc: post['Description'] ?? 'No Description',
                                onAvatarTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrganizationDetailsPage(
                                            oid: post['OID'],
                                          ),
                                    ),
                                  );
                                },
                                imageUrls: post['mediaUrls'],
                                date: post['CreatedAt'] != null
                                    ? formatDate(post['CreatedAt'])
                                    : 'NA',
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
