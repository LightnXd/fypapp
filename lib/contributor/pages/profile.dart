import 'package:flutter/material.dart';
import 'package:fypapp2/widget/icon_box.dart';
import 'package:fypapp2/widget/empty_box.dart';
import '../../services/profile.dart';
import '../../widget/profile_head.dart';

class ContributorProfilePage extends StatefulWidget {
  const ContributorProfilePage({super.key});

  @override
  State<ContributorProfilePage> createState() => _ContributorProfilePageState();
}

class _ContributorProfilePageState extends State<ContributorProfilePage> {
  String username = 'aa';
  String id = 'aa';
  String country = 'aa';
  String birthDate = 'aa';
  String? profileImage;
  String? backgroundImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadContributorProfile();
  }

  Future<void> loadContributorProfile() async {
    try {
      final data = await fetchContributorProfile();
      setState(() {
        id = data['ID'].toString();
        username = data['Username'];
        country = data['Country'];
        birthDate = data['Birthdate'].toString();
        profileImage = data['ProfileImage'];
        backgroundImage = data['BackgroundImage'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.floor();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '<  contributor profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    profileUrl: profileImage,
                    backgroundUrl: backgroundImage,
                  ),

                  SizedBox(height: screenWidth / 4.3),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        horizontalIcon(
                          imagePath: 'assets/images/test.webp',
                          text: username,
                          spacing: 12,
                        ),
                        horizontalIcon(
                          imagePath: 'assets/images/test.webp',
                          text: id,
                          spacing: 12,
                        ),
                        horizontalIcon(
                          imagePath: 'assets/images/test.webp',
                          text: country,
                          spacing: 12,
                        ),
                        horizontalIcon(
                          imagePath: 'assets/images/test.webp',
                          text: birthDate,
                          spacing: 12,
                        ),
                        gaph24,
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle press
                            },
                            child: Text('Centered Button'),
                          ),
                        ),
                        gaph24,
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
