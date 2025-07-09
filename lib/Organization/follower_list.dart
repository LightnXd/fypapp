import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/organization_details.dart';
import '../services/authentication.dart';
import '../services/follow.dart';
import '../widget/app_bar.dart';
import '../widget/avatar_box.dart';
import '../widget/empty_box.dart';

class FollowerListPage extends StatefulWidget {
  const FollowerListPage({super.key});

  @override
  State<FollowerListPage> createState() => _FollowerListPageState();
}

class _FollowerListPageState extends State<FollowerListPage> {
  final AuthenticationService _authService = AuthenticationService();
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  List<Map<String, dynamic>> _originalList = [];
  List<Map<String, dynamic>> _filteredList = [];

  @override
  void initState() {
    super.initState();
    getFollowerList();
  }

  Future<void> getFollowerList() async {
    try {
      final oid = await _authService.getCurrentUserID();
      if (oid == null) {
        throw Exception("User ID is null.");
      }

      final data = await getFollowerUsers(oid);

      setState(() {
        _originalList = data;
        _filteredList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching follower list: $e');
    }
  }

  void _filterList(String query) {
    final filtered = _originalList.where((user) {
      final username = user['Username']?.toLowerCase() ?? '';
      final id = user['ID']?.toLowerCase() ?? '';

      return username.contains(query.toLowerCase()) ||
          id.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredList = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'View Follower'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _originalList.isEmpty
          ? const Center(child: Text('No follower found.'))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                gaph20,
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search follower...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: _filterList,
                ),
                gaph32,
                ..._filteredList.map((user) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                OrganizationDetailsPage(oid: user['ID']),
                          ),
                        );
                      },
                      child: AvatarBox(
                        imageUrl: user['ProfileImage'],
                        orgName: user['Username'],
                        desc: user['ID'],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
    );
  }
}
