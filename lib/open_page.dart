import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypapp2/services/authentication.dart';
import 'package:fypapp2/services/profile.dart';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;

class OpenPage extends StatefulWidget {
  const OpenPage({super.key});

  @override
  State<OpenPage> createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      refresh();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> refresh() async {
    await _checkSession();
  }

  Future<void> _checkSession() async {
    final authService = AuthenticationService();
    final session = authService.client.auth.currentSession;

    if (session == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final email = session.user?.email;

      if (email == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final response = await http.post(
        Uri.parse(checkUserCreatedUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to check user registration');
      }

      final data = jsonDecode(response.body);
      final isRegistered = data['created'] == true;

      if (!isRegistered) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final id = await authService.getCurrentUserID();
      if (id == null || !mounted) return;

      final userRole = await getUserRole(id);
      if (!mounted) return;
      switch (userRole) {
        case 'Contributor':
          Navigator.pushReplacementNamed(context, '/contributor-main');
          break;
        case 'Organization':
          Navigator.pushReplacementNamed(context, '/organization-main');
          break;
        default:
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Role not found')));
          Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e, stack) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking registration: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
