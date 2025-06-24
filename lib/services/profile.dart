import 'dart:convert';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'authentication.dart';

Future<Map<String, dynamic>> getContributorProfile() async {
  final uid = Supabase.instance.client.auth.currentUser?.id;

  if (uid == null) {
    throw Exception("No session found.");
  }

  final AuthenticationService authService = AuthenticationService();
  final id = await authService.getCurrentUserID(uid);

  if (id == null) {
    throw Exception("No user found.");
  }

  final Uri url = Uri.parse('$getContributorProfileUrl?id=$id');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final err = jsonDecode(response.body);
    throw Exception(err["error"] ?? "Unknown error occurred.");
  }
}

Future<Map<String, dynamic>> getOrganizationProfile() async {
  final uid = Supabase.instance.client.auth.currentUser?.id;

  if (uid == null) {
    throw Exception("No session found.");
  }

  final AuthenticationService authService = AuthenticationService();
  final id = await authService.getCurrentUserID(uid);

  if (id == null) {
    throw Exception("No user found.");
  }

  final Uri url = Uri.parse('$getOrganizationProfileUrl?id=$id');
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

Future<String?> getUserRole(String id) async {
  try {
    final response = await http.get(Uri.parse('$getRoleUrl?id=$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['Role'] as String?;
    } else {
      print('Failed to fetch status: ${response.body}');
    }
  } catch (e) {
    print('Exception in getUserStatus: $e');
  }

  return null;
}

Future<Map<String, String>?> getUserImages(String id) async {
  try {
    final response = await http.get(Uri.parse('$getImageUrl?id=$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'ProfileImage': data['ProfileImage'] ?? '',
        'BackgroundImage': data['BackgroundImage'] ?? '',
      };
    } else {
      print('Failed to fetch images: ${response.body}');
    }
  } catch (e) {
    print('Exception in getUserImages: $e');
  }

  return null;
}

Future<String?> getUserStatus(String id) async {
  try {
    final response = await http.get(Uri.parse('$getStatusUrl?id=$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['Status'] as String);
      return data['Status'] as String?;
    } else {
      print('Failed to fetch status: ${response.body}');
    }
  } catch (e) {
    print('Exception in getUserStatus: $e');
  }

  return null;
}
