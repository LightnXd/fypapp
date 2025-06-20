import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/pages/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userEmail = supabase.auth.currentUser?.email ?? 'No email found';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
              // Navigate to login page after logout
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text('Welcome, $userEmail'),
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
              child: Text('Centered Button'),
            ),
          ),
        ],
      ),
    );
  }
}
