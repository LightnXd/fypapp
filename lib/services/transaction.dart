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

Future<List<Map<String, dynamic>>> getActiveProposalsByFollower(
  String cid,
) async {
  final url = Uri.parse('$getActiveProposalListbyFollowerUrl?cid=$cid');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.cast<Map<String, dynamic>>();
  } else {
    final error = json.decode(response.body);
    throw Exception('Failed to load proposals: ${error['error']}');
  }
}

Future<void> createProposalRequest({
  required String oid,
  required String title,
  required String description,
  required double amount,
  required String endDate,
}) async {
  final response = await http.post(
    Uri.parse(createProposalUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'oid': oid,
      'title': title,
      'description': description,
      'amount': amount,
      'endDate': endDate,
    }),
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
  } else {
    final error = jsonDecode(response.body);
    throw Exception('Failed to create proposal: ${error['error']}');
  }
}

Future<Map<String, dynamic>> getVote({
  required String proposalId,
  required String cid,
}) async {
  final url = Uri.parse('$getVoteUrl?proposalid=$proposalId&cid=$cid');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {'voteid': data['voteid'], 'vote': data['vote']};
  } else {
    final error = json.decode(response.body);
    throw Exception('Failed to load vote: ${error['error']}');
  }
}

Future<Map<String, dynamic>> changeProposalStatus({
  required String proposalid,
  required String status,
}) async {
  final url = Uri.parse(changeProposalStatusUrl);

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'proposalid': proposalid, 'status': status}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to confirm proposal status: ${response.body}');
  }
}

Future<void> castVote({
  required String proposalid,
  required String cid,
  required bool vote,
}) async {
  final response = await http.post(
    Uri.parse(castVoteUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'proposalid': proposalid, 'cid': cid, 'vote': vote}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
    } else {
      throw Exception('Vote failed: ${data['error'] ?? 'Unknown error'}');
    }
  } else {
    throw Exception('Server error: ${response.statusCode} ${response.body}');
  }
}

Future<Map<String, dynamic>> getVoteStat(String pid) async {
  final uri = Uri.parse('$getVoteStatUrl?pid=$pid');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load vote stats');
  }
}
