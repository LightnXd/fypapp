//import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http show post;
import 'package:supabase_flutter/supabase_flutter.dart';



class AuthenticationService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<bool> signUp(String email) async {
    print('📤 signUp called with email: $email');
    final baseUrl = 'http://10.101.39.125:8000';

    // Step 1: Check status
    final statusResponse = await http.post(
      Uri.parse('$baseUrl/auth/check-status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    print(statusResponse);
    print(statusResponse.statusCode);
    print(statusResponse.body);

    if (statusResponse.statusCode != 200) {
      throw Exception('Failed to check email: ${statusResponse.body}');
    }

    final statusData = jsonDecode(statusResponse.body);
    final shouldSendOtp = statusData['status'] == true;

    // Step 2: If true, trigger Supabase OTP email
    if (shouldSendOtp) {
      final otpResponse = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (otpResponse.statusCode != 200) {
        throw Exception('Failed to send OTP: ${otpResponse.body}');
      }

      return true; // Proceed with OTP
    }

    return false; // Email already confirmed
  }




  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Invalid credentials.');
      }

      await sendOtp(email: email);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendOtp({
    required String email,
  }) async {
    try {
      await _client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.supabase.flutter://callback',
      );
    } on AuthException catch (e) {
      throw Exception('Failed to send OTP: ${e.message}');
    }
  }

  Future<bool> verifyOtp({
    required String email,
    required String token,
  }) async {
    final response = await _client.auth.verifyOTP(
      type: OtpType.email,
      email: email,
      token: token,
    );
    return response.user != null;
  }

  Future<void> logOut() async {
    await _client.auth.signOut();
  }


}

