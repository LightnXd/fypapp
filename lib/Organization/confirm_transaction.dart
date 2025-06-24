import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../contributor/pages/ledger.dart';
import '../services/authentication.dart';
import '../widget/app_bar.dart';
import '../widget/empty_box.dart';

class ConfirmTransactionPage extends StatefulWidget {
  const ConfirmTransactionPage({super.key});

  @override
  State<ConfirmTransactionPage> createState() => _ConfirmTransactionPageState();
}

class _ConfirmTransactionPageState extends State<ConfirmTransactionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final supabase = Supabase.instance.client;
  final AuthenticationService _authService = AuthenticationService();

  late String oid;
  late double amount;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final uid = user.id;
    final id = await _authService.getCurrentUserID(uid);
    if (id == null) {
      return;
    }

    if (mounted) {
      setState(() {
        oid = id;
      });
    }
  }

  Future<void> _sendTransaction(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(addBlockUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'OID': oid, 'Amount': amount}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Transaction successful. LedgerID: ${data['LedgerID']}',
            ),
          ),
        );
      } else {
        throw Exception(data['error'] ?? 'Transaction failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Confirm Transaction', type: 2),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Do you want to confirm this transaction?'),
            gaph16,
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ContributorLedgerPage(),
                  ),
                );
              },
              child: const Text('Switch Page'),
            ),
            ElevatedButton(
              onPressed: () => _sendTransaction(context),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
