import 'dart:convert';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http show post, Response, get;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService {
  final SupabaseClient _client = Supabase.instance.client;

  SupabaseClient get client => _client;

  Future<bool> getSession(String? sessionString) async {
    if (sessionString == null) return false;

    try {
      final recoveredSession = await _client.auth.recoverSession(sessionString);
      return recoveredSession.session != null;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, String>>> getOrganizationTypes() async {
    final response = await http.get(Uri.parse(getOrganizationTypeUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map<Map<String, String>>((item) {
        return {
          'TID': item['TID'].toString(),
          'TypeName': item['TypeName'] ?? '',
        };
      }).toList();
    } else {
      throw Exception('Failed to load organization types: ${response.body}');
    }
  }

  Future<bool> signUp(String email) async {
    final statusResponse = await http.post(
      Uri.parse(checkStatusUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (statusResponse.statusCode != 200) {
      throw Exception('Failed to check email: ${statusResponse.body}');
    }

    final statusData = jsonDecode(statusResponse.body);
    final shouldSendOtp = statusData['status'] == true;

    if (shouldSendOtp) {
      return await sendOTP(email);
    }

    return false;
  }

  Future<Map<String, dynamic>> verifyUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(verifyUserUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    return {
      'status': response.statusCode == 200 && data['status'] == true,
      'message': data['message'] ?? 'An unknown error occurred',
    };
  }

  Future<bool> sendOTP(String email) async {
    final otpResponse = await http.post(
      Uri.parse(sendOTPUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (otpResponse.statusCode != 200) {
      throw Exception('Failed to send OTP: ${otpResponse.body}');
    }

    return true;
  }

  Future<http.Response> verifyOTP({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse(verifyOTPurl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'token': otp, 'type': 'email'}),
    );
    return response;
  }

  Future<bool> setPassword(String password) async {
    final response = await Supabase.instance.client.auth.updateUser(
      UserAttributes(password: password),
    );
    return response.user != null;
  }

  Future<bool> createContributor({
    required String email,
    required String name,
    required String country,
    required String birthdate,
  }) async {
    final creationResponse = await http.post(
      Uri.parse(createContributorUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'name': name,
        'country': country,
        'birthdate': birthdate,
      }),
    );

    if (creationResponse.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> createOrganization({
    required String email,
    required String name,
    required String country,
    required String description,
    required String address,
    required List<String> type,
  }) async {
    final creationResponse = await http.post(
      Uri.parse(createOrganizationUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'name': name,
        'country': country,
        'description': description,
        'address': address,
        'type': type,
      }),
    );

    if (creationResponse.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<String?> getCurrentUserID() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$getCurrentIDUrl?uid=${user.id}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return data['data']['ID'] as String;
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }

    return null;
  }
}
