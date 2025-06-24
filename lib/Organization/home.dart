import 'package:flutter/material.dart';
import 'package:fypapp2/Organization/profile.dart';
import 'package:fypapp2/widget/side_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/authentication.dart';
import '../services/profile.dart';
import '../widget/app_bar.dart';

class OrganizationHomePage extends StatefulWidget {
  const OrganizationHomePage({super.key});

  @override
  State<OrganizationHomePage> createState() => _OrganizationHomePageState();
}

class _OrganizationHomePageState extends State<OrganizationHomePage> {
  final supabase = Supabase.instance.client;
  final AuthenticationService _authService = AuthenticationService();

  String? status;
  String? userEmail;
  String? id;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserStatus();
  }

  Future<void> fetchUserStatus() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('User is null');
      setState(() => isLoading = false);
      return;
    }

    final uid = user.id;
    userEmail = user.email;
    print('UID: $uid, Email: $userEmail');

    id = await _authService.getCurrentUserID(uid);
    if (id == null) {
      print('UserID not found');
      setState(() => isLoading = false);
      return;
    }

    final userStatus = await getUserStatus(id!);
    print('UserStatus: $userStatus');

    if (mounted) {
      setState(() {
        status = userStatus;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Organization Home (change later)', type: 1),
      drawer: OrganizationSideBar(userId: id!), // ✅ Use real id
      body: status == 'Pending'
          ? const Center(child: Text('Your account has not been approved'))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome, $userEmail'),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrganizationProfilePage(),
                        ),
                      );
                    },
                    child: const Text('Go to Profile'),
                  ),
                ),
              ],
            ),
    );
  }
}
