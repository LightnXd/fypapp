import 'package:flutter/material.dart';
import 'package:fypapp2/Organization/main_page.dart';
import 'package:fypapp2/Organization/profile.dart';
import 'package:fypapp2/contributor/organization_details.dart';
import 'package:fypapp2/services/date_converter.dart';
import 'package:fypapp2/widget/post_view.dart';
import 'package:fypapp2/widget/side_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/authentication.dart';
import '../services/posting.dart';
import '../services/profile.dart';
import '../widget/dynamic_image_view.dart';
import '../widget/app_bar.dart';
import '../widget/avatar_box.dart';
import '../widget/empty_box.dart';
import '../widget/navigation_bar.dart';
import '../widget/response_dialog.dart';

class OrganizationHomePage extends StatefulWidget {
  OrganizationHomePage({Key? key}) : super(key: key);

  @override
  OrganizationHomePageState createState() => OrganizationHomePageState();
}

class OrganizationHomePageState extends State<OrganizationHomePage> {
  final AuthenticationService _authService = AuthenticationService();

  String? status;
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
    final user = _authService.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('user not found')));
      return;
    }
    id = await _authService.getCurrentUserID();
    if (id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('user id not found')));
      setState(() => isLoading = false);
      return;
    }

    final userStatus = await getUserStatus(id!);

    if (mounted) {
      setState(() {
        id = id;
        status = userStatus;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Home', type: 1),
      drawerEnableOpenDragGesture: false,
      drawer: OrganizationSideBar(userId: id),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : status != 'Active'
          ? const Center(child: Text('Your account have been suspended'))
          : RefreshIndicator(
              onRefresh: refresh,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
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
                                              type: false,
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
            ),
    );
  }
}
