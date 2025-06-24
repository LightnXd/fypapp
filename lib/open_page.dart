import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypapp2/services/authentication.dart';
import 'package:fypapp2/services/profile.dart';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class OpenPage extends StatefulWidget {
  const OpenPage({super.key});

  @override
  State<OpenPage> createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  Future<void> _checkSession() async {
    print("called");
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;
    final authService = AuthenticationService();
    print('session: $session');

    if (session == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final email = session.user?.email;
      print('email: $email');

      if (email == null) {
        print('Email is null!');
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      print('Sending request to $checkUserCreatedUrl');
      final response = await http.post(
        Uri.parse(checkUserCreatedUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print('response status: ${response.statusCode}');
      print('response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to check user registration');
      }

      final data = jsonDecode(response.body);
      print('data: $data');
      final isRegistered = data['created'] == true;

      if (!isRegistered) {
        print('User is not registered');
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final uid = session.user.id;
      print('uid: $uid');

      final id = await authService.getCurrentUserID(uid);
      print('id: $id');

      if (id == null || !mounted) return;

      final userRole = await getUserRole(id);
      print('userRole: $userRole');

      if (!mounted) return;

      switch (userRole) {
        case 'Contributor':
          Navigator.pushReplacementNamed(context, '/contributor-home');
          break;
        case 'Organization':
          Navigator.pushReplacementNamed(context, '/organization-home');
          break;
        default:
          print('Unknown role');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Role not found')));
          Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e, stack) {
      print('Error in _checkSession: $e');
      print(stack);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking registration: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("openpage");
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
