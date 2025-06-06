import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;

import '../contributor/pages/ledger.dart';

class ConfirmTransactionPage extends StatelessWidget {
  const ConfirmTransactionPage({super.key});

  Future<void> _sendTransaction(BuildContext context) async {
    const OID = 'id552'; // You can pass this dynamically
    const amount = 250.75;

    try {
      final response = await http.post(
        Uri.parse(addBlockUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'OID': OID, 'Amount': amount}),
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
      appBar: AppBar(title: const Text('Confirm Transaction')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Do you want to confirm this transaction?'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LedgerPage()),
                );
              },
              child: const Text('switch page'),
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
