//import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class AuthenticationService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'io.supabase.flutter://callback',
      );

      return true;
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('user already registered')) {
        return false; // user already exists
      }
      throw Exception('Sign up error: ${e.message}');
    } catch (e) {
      rethrow;
    }
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

 /* Future<void> sendotp2({required String email}) async {
    EmailAuth emailAuth =  new EmailAuth(sessionName: "Sample session");
    bool result = await emailAuth.sendOtp(
        recipientMail: email, otpLength: 6
    );
  }*/
}

