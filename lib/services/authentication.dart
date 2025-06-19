//import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http show post, Response;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<bool> getSession(String? sessionString) async {
    if (sessionString == null) return false;

    try {
      final recoveredSession = await _client.auth.recoverSession(sessionString);
      return recoveredSession.session != null;
    } catch (e) {
      print('Error restoring session: $e');
      return false;
    }
  }

  Future<bool> signUp(String email) async {
    // Step 1: Check status
    final statusResponse = await http.post(
      Uri.parse(checkStatusurl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (statusResponse.statusCode != 200) {
      throw Exception('Failed to check email: ${statusResponse.body}');
    }

    final statusData = jsonDecode(statusResponse.body);
    final shouldSendOtp = statusData['status'] == true;

    // Step 2: If true, send OTP
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
      Uri.parse(sendOTPurl),
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
  }) async {
    final creationResponse = await http.post(
      Uri.parse(createOrganizationUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'name': name,
        'country': country,
        'description': description,
      }),
    );

    if (creationResponse.statusCode == 200)
      return true;
    else
      return false;
  }
}
