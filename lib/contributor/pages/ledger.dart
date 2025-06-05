import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widget/empty_box.dart';
import 'ledger_details.dart';

class LedgerPage extends StatefulWidget {
  final String oid;

  const LedgerPage({super.key, this.oid = '111'});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  late Stream<List<Map<String, dynamic>>> _ledgerStream;

  @override
  void initState() {
    super.initState();
    _ledgerStream = Supabase.instance.client
        .from('ledger')
        .stream(primaryKey: ['LedgerID'])
        .eq('OID', widget.oid)
        .order('Index', ascending: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ledger Records')),
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
                      final rowOid = entry['OID'] ?? 'Unknown';
                      final cid = entry['CID'] ?? 'Unknown';
                      final amount = entry['Amount'] ?? 'Unknown';
                      final hash = entry['Hash'] ?? 'No Hash';
                      final previousHash =
                          entry['PreviousHash'] ?? 'No Previous Hash';

                      return ListTile(
                        title: Text('OID: $rowOid'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CID: $cid'),
                            Text('Amount: $amount'),
                            Text('Hash: $hash'),
                            Text('Previous Hash: $previousHash'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LedgerDetailPage(
                                oid: rowOid,
                                title: cid.toString(),
                              ),
                            ),
                          );
                        },
                      );
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

    final excel = Excel.createExcel(); // Default sheet is created
    final String sheetName = excel.getDefaultSheet()!;
    final Sheet sheet = excel.sheets[sheetName]!;

    // Add header row
    sheet.appendRow([
      TextCellValue('Index'),
      TextCellValue('Hash'),
      TextCellValue('PreviousHash'),
      TextCellValue('CID'),
      TextCellValue('OID'),
      TextCellValue('Amount'),
      TextCellValue('CreationDate'),
    ]);

    for (final entry in snapshot) {
      sheet.appendRow([
        TextCellValue(entry['Index']?.toString() ?? ''),
        TextCellValue(entry['Hash']?.toString() ?? ''),
        TextCellValue(entry['PreviousHash']?.toString() ?? ''),
        TextCellValue(entry['CID']?.toString() ?? ''),
        TextCellValue(entry['OID']?.toString() ?? ''),
        TextCellValue(entry['Amount']?.toString() ?? ''),
        TextCellValue(entry['CreationDate']?.toString() ?? ''),
      ]);
    }

    // Save the Excel to a temp file
    final bytes = excel.encode()!;
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/ledger.xlsx';
    final tempFile = File(tempPath);
    await tempFile.writeAsBytes(bytes);
    print('File saved to: $tempPath');

    // Prompt user to save via FlutterFileDialog
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
