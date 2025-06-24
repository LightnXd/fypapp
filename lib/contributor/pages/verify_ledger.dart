import 'package:flutter/material.dart';

import '../../services/ledger.dart';
import '../../widget/app_bar.dart';

class VerifyLedgerPage extends StatefulWidget {
  const VerifyLedgerPage({super.key});

  @override
  State<VerifyLedgerPage> createState() => _VerifyLedgerPageState();
}

class _VerifyLedgerPageState extends State<VerifyLedgerPage> {
  String statusMessage = "No file selected";

  Future<void> handleUpload() async {
    final result = await pickAndUploadLedgerFile();
    setState(() => statusMessage = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Verify Ledger', type: 2),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: handleUpload,
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload Excel File"),
            ),
            const SizedBox(height: 20),
            SelectableText(
              statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
