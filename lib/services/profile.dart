import 'dart:convert';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> fetchContributorProfile() async {
  final uid = Supabase.instance.client.auth.currentUser?.id;
  if (uid == null) {
    throw Exception("No user found.");
  }

  final Uri url = Uri.parse('$getContributorProfileUrl?uid=$uid');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final err = jsonDecode(response.body);
    throw Exception(err["error"] ?? "Unknown error occurred.");
  }
}

Future<Map<String, dynamic>> fetchOrganizationProfile() async {
  final uid = Supabase.instance.client.auth.currentUser?.id;
  if (uid == null) {
    throw Exception("No user found.");
  }

  final Uri url = Uri.parse('$getOrganizationProfileUrl?uid=$uid');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final err = jsonDecode(response.body);
    throw Exception(err["error"] ?? "Unknown error occurred.");
  }
}

Future<bool> editContributorProfile({
  required String id,
  required String username,
  required String country,
}) async {
  final response = await http.post(
    Uri.parse(editContributorProfileUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id': id, 'username': username, 'country': country}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['success'] == true;
  } else {
    return false;
  }
}

Future<bool> editOrganizationProfile({
  required String id,
  required String username,
  required String address,
  required String description,
  required String country,
}) async {
  final response = await http.post(
    Uri.parse(editOrganizationProfileUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'id': id,
      'username': username,
      'address': address,
      'description': description,
      'country': country,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['success'] == true;
  } else {
    return false;
  }
}
