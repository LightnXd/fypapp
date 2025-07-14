import 'dart:convert';

import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;

Future<String?> createPost({
  required String oid,
  required String title,
  required String description,
}) async {
  try {
    final response = await http.post(
      Uri.parse(createPostUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'oid': oid,
        'tittle': title,
        'description': description,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data['postId'];
    } else {
      throw Exception(data['error'] ?? 'Unknown error');
    }
  } catch (e) {
    throw Exception('Exception occurred: $e');
  }
}

Future<List<Map<String, dynamic>>> getAllPost() async {
  try {
    final response = await http.get(Uri.parse(getAllPostUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // For each Map in the list, cast mediaUrls into `List<String>?`
      return data.map((raw) {
        final Map<String, dynamic> post = Map<String, dynamic>.from(raw);
        final rawUrls = post['mediaUrls'];
        post['mediaUrls'] = rawUrls != null
            ? List<String>.from(rawUrls as List<dynamic>)
            : null;
        return post;
      }).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    print('Error fetching posts: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> getAllFollowedPost(String cid) async {
  final uri = Uri.parse('$getAllFollowedPostUrl?cid=$cid');
  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((raw) {
        final Map<String, dynamic> post = Map<String, dynamic>.from(raw);
        final rawUrls = post['mediaUrls'];
        post['mediaUrls'] = rawUrls != null
            ? List<String>.from(rawUrls as List<dynamic>)
            : null;
        return post;
      }).toList();
    } else {
      throw Exception(
        'Failed to fetch posts. Status code: ${response.statusCode}',
      );
    }
  } catch (e) {
    throw Exception('Error fetching followed posts: $e');
  }
}

Future<void> addMediaLinks({
  required String postId,
  required List<String> links,
}) async {
  try {
    final response = await http.post(
      Uri.parse(mediaLinkUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'postId': postId, 'links': links}),
    );

    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception('Error: ${data['error'] ?? 'Unknown error'}');
    }
  } catch (e) {
    print('Exception while uploading media links: $e');
    rethrow; // optionally rethrow to let the caller handle it too
  }
}
