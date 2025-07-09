import 'package:flutter/material.dart';
import 'package:fypapp2/Organization/confirm_proposal.dart';
import 'package:fypapp2/contributor/ledger.dart';
import 'package:fypapp2/contributor/profile.dart';
import 'Organization/home.dart';
import 'contributor/home.dart';
import 'contributor/make_donation.dart';
import 'login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'open_page.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://mgpdbmetguvktlbczdmf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ncGRibWV0Z3V2a3RsYmN6ZG1mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3MjAzNTQsImV4cCI6MjA2NDI5NjM1NH0.ivG9nA_IqTzxnTBEZsw_EbUYr1MYbxUqxhs6qCaqv0k',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const OpenPage(),
        '/login': (context) => LoginPage(),
        '/contributor-home': (context) => const ContributorHomePage(),
        '/organization-home': (context) => const OrganizationHomePage(),
      },
    );
  }
}
