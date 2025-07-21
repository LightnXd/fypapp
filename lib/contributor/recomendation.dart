import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/organization_details.dart';
import 'package:fypapp2/services/date_converter.dart';
import 'package:fypapp2/widget/side_bar.dart';
import '../services/authentication.dart';
import '../services/posting.dart';
import '../widget/app_bar.dart';
import '../widget/avatar_box.dart';
import '../widget/empty_box.dart';
import '../widget/navigation_bar.dart';
import '../widget/post_view.dart';
import '../widget/response_dialog.dart';

class ContributorRecommendationPage extends StatefulWidget {
  const ContributorRecommendationPage({Key? key}) : super(key: key);

  @override
  ContributorRecommendationPageState createState() =>
      ContributorRecommendationPageState();
}

class ContributorRecommendationPageState
    extends State<ContributorRecommendationPage> {
  final AuthenticationService _authService = AuthenticationService();

  String? id;
  bool isLoading = true;
  List<Map<String, dynamic>> _originalList = [];
  List<Map<String, dynamic>> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isPostLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserStatus();
    fetchPosts();
  }

  Future<void> refresh() async {
    setState(() => isLoading = true);
    await fetchPosts();
  }

  Future<void> fetchPosts() async {
    final posts = await getAllPost();
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

  Future<void> fetchUserStatus() async {
    try {
      final fetchedId = await _authService.getCurrentUserID();
      if (fetchedId == null) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => ResponseDialog(
              title: 'Error',
              message: 'User ID not found',
              type: false,
            ),
          );
          setState(() => isLoading = true);
        }
        return;
      }

      if (mounted) {
        setState(() {
          id = fetchedId;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => ResponseDialog(
            title: 'Users not Found',
            message: 'Error fetching user ID: $e',
            type: false,
          ),
        );
        setState(() => isLoading = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Recommendation', type: 1),
      drawerEnableOpenDragGesture: false,
      drawer: ContributorSideBar(userId: id),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                    OrganizationDetailsPage(oid: post['OID']),
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
