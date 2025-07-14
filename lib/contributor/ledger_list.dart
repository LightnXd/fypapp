import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Organization/proposal_list.dart';
import '../widget/app_bar.dart';
import '../widget/empty_box.dart';
import '../widget/ledger_list.dart';
import '../widget/navigation_bar.dart';
import '../widget/side_bar.dart';

class ContributorLedgerPage extends StatefulWidget {
  final String oid;

  const ContributorLedgerPage({super.key, required this.oid});

  @override
  State<ContributorLedgerPage> createState() => _ContributorLedgerPageState();
}

class _ContributorLedgerPageState extends State<ContributorLedgerPage> {
  late Stream<List<Map<String, dynamic>>> _ledgerStream;

  Stream<List<Map<String, dynamic>>> ledgerStream(String oid) async* {
    while (true) {
      try {
        yield* Supabase.instance.client
            .from('ledger')
            .stream(primaryKey: ['LedgerID'])
            .eq('OID', oid)
            .order('TransactionNumber', ascending: false);
        break;
      } catch (e, st) {
        debugPrint('Realtime stream error: $e\n$st');
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _ledgerStream = ledgerStream(widget.oid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Ledger List"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OID: ${widget.oid}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            gaph8,
            const Text('Related ledger entries:'),
            gaph8,
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrganizationProposalListPage(),
                  ),
                );
              },
              child: const Text('switch page'),
            ),
            gaph8,
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Export as Excel'),
              onPressed: () => _downloadAsExcel(context),
            ),
            gaph16,
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _ledgerStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SelectableText('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final entries = snapshot.data!;
                  if (entries.isEmpty) {
                    return const Text('No entries found.');
                  }

                  return ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return LedgerList(entry: entry);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadAsExcel(BuildContext context) async {
    final snapshot = await _ledgerStream.first;

    if (snapshot.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No data to export.')));
      return;
    }
    final excel = Excel.createExcel();
    final String sheetName = excel.getDefaultSheet()!;
    final Sheet sheet = excel.sheets[sheetName]!;

    sheet.appendRow([
      TextCellValue('LedgerID'),
      TextCellValue('TransactionNumber'),
      TextCellValue('Hash'),
      TextCellValue('PreviousHash'),
      TextCellValue('CID'),
      TextCellValue('OID'),
      TextCellValue('Amount'),
      TextCellValue('CreationDate'),
    ]);

    for (final entry in snapshot) {
      sheet.appendRow([
        TextCellValue(entry['LedgerID']?.toString() ?? ''),
        TextCellValue(entry['TransactionNumber']?.toString() ?? ''),
        TextCellValue(entry['Hash']?.toString() ?? ''),
        TextCellValue(entry['PreviousHash']?.toString() ?? ''),
        TextCellValue(entry['CID']?.toString() ?? ''),
        TextCellValue(entry['OID']?.toString() ?? ''),
        TextCellValue(entry['Amount']?.toString() ?? ''),
        TextCellValue(entry['CreationDate']?.toString() ?? ''),
      ]);
    }

    final bytes = excel.encode()!;
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/ledger.xlsx';
    final tempFile = File(tempPath);
    await tempFile.writeAsBytes(bytes);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('File saved to: $tempPath')));

    final savedPath = await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(sourceFilePath: tempPath),
    );

    if (savedPath != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Excel saved to: $savedPath')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Save cancelled.')));
    }
  }
}
