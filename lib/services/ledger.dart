import 'dart:convert';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

Future<String> pickAndUploadLedgerFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
    withData: true, // <---- ADD THIS
  );

  if (result == null) return "File selection cancelled";

  final fileBytes = result.files.single.bytes;
  final fileName = result.files.single.name;

  if (fileBytes == null) return "File bytes are null";

  var request = http.MultipartRequest('POST', Uri.parse(verifyBlockUrl));

  request.files.add(
    http.MultipartFile.fromBytes(
      'ledger_file', // <-- must match your backend field name
      fileBytes,
      filename: fileName,
      contentType: MediaType(
        'application',
        'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      ),
    ),
  );

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    return result['valid'] == true
        ? "Ledger is valid"
        : "Ledger has been tampered";
  } else {
    return "Error: ${response.body}";
  }
}

Future<List<Map<String, dynamic>>> getActiveProposal(String oid) async {
  // Replace with your actual server URL
  final response = await http.get(
    Uri.parse('$getActiveProposalListUrl?oid=$oid'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.cast<Map<String, dynamic>>();
  } else {
    final error = json.decode(response.body);
    throw Exception('Failed to load proposals: ${error['error']}');
  }
}
