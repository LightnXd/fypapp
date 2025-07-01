import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/profile.dart';
import 'package:fypapp2/widget/app_bar.dart';
import 'package:fypapp2/widget/navigation_bar.dart';
import 'package:fypapp2/widget/side_bar.dart';

import '../services/authentication.dart';

class ContributorHomePage extends StatefulWidget {
  const ContributorHomePage({super.key});

  @override
  State<ContributorHomePage> createState() => _ContributorHomePageState();
}

class _ContributorHomePageState extends State<ContributorHomePage> {
  final AuthenticationService _authService = AuthenticationService();
  String userEmail = 'Loading...';
  String cid = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final user = _authService.client.auth.currentUser;
    if (user != null) {
      userEmail = user.email ?? 'No email found';
      final uid = user.id;
      final fetchedCid = await _authService.getCurrentUserID(uid);
      setState(() {
        cid = fetchedCid!;
        isLoading = false;
      });
    } else {
      setState(() {
        userEmail = 'No user found';
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
      appBar: CustomAppBar(title: "Home", type: 1),
      bottomNavigationBar: ContributorNavBar(),
      drawerEnableOpenDragGesture: false,
      drawer: ContributorSideBar(userId: cid),
      body: Column(
        children: [
          Text('Welcome, $cid, $userEmail'),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ContributorProfilePage(),
                  ),
                );
              },
              child: const Text('Centered Button'),
            ),
          ),
        ],
      ),
    );
  }
}
