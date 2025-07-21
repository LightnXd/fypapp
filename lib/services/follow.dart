import 'dart:convert';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;

import 'authentication.dart';

Future<List<Map<String, dynamic>>> getFollowedUsers(String cid) async {
  final response = await http.get(Uri.parse('$getFollowedUrl?cid=$cid'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map<Map<String, dynamic>>(
          (item) => {
            'ID': item['ID'],
            'Username': item['Username'],
            'ProfileImage': item['ProfileImage'],
          },
        )
        .toList();
  } else {
    throw Exception(
      'Failed to fetch followed organization: ${response.reasonPhrase}',
    );
  }
}

Future<List<Map<String, dynamic>>> getFollowerUsers(String oid) async {
  final response = await http.get(Uri.parse('$getFollowerUrl?oid=$oid'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map<Map<String, dynamic>>(
          (item) => {
            'ID': item['ID'],
            'Username': item['Username'],
            'ProfileImage': item['ProfileImage'],
          },
        )
        .toList();
  } else {
    throw Exception('Failed to fetch followers: ${response.reasonPhrase}');
  }
}

Future<bool> isFollowing(String oid, String cid) async {
  final supabase = AuthenticationService().client;

  final response = await supabase
      .from('Follow')
      .select()
      .eq('FollowedID', oid)
      .eq('FollowerID', cid)
      .maybeSingle();

  return response != null;
}

Future<bool> followOrganization(String oid, String cid) async {
  try {
    final response = await http.post(
      Uri.parse(followUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'oid': oid, 'cid': cid}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Follow failed: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error during follow: $e');
    return false;
  }
}

Future<bool> unfollowOrganization(String oid, String cid) async {
  try {
    final response = await http.post(
      Uri.parse(unfollowUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'oid': oid, 'cid': cid}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Unfollow failed: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error during unfollow: $e');
    return false;
  }
}

Future<int> fetchCountByOID(String oid) async {
  final response = await http.get(
    Uri.parse(getFollowCountUrl).replace(queryParameters: {'oid': oid}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['count'] as int?) ?? 0;
  } else {
    throw Exception('Failed to fetch count. Status: ${response.statusCode}');
  }
}
