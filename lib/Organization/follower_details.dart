import 'package:flutter/material.dart';
import 'package:fypapp2/services/date_converter.dart';
import 'package:fypapp2/widget/icon_box.dart';
import 'package:fypapp2/widget/empty_box.dart';
import '../services/profile.dart';
import '../widget/app_bar.dart';
import '../widget/profile_head.dart';
import 'edit_profile.dart';

class FollowerDetailsPage extends StatefulWidget {
  final cid;
  const FollowerDetailsPage({super.key, required this.cid});

  @override
  State<FollowerDetailsPage> createState() => _FollowerDetailsPageState();
}

class _FollowerDetailsPageState extends State<FollowerDetailsPage> {
  String username = '';
  String id = '';
  String country = '';
  String birthDate = '';
  String? profileImage;
  String? backgroundImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContributorProfile();
  }

  Future<void> loadContributorProfile() async {
    try {
      final data = await getContributorProfile(cid: widget.cid);
      setState(() {
        id = data['ID'].toString();
        username = data['Username'];
        country = data['Country'];
        birthDate = formatDate(data['Birthdate']);
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
      appBar: CustomAppBar(title: "Follower Details"),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        horizontalIcon(
                          imagePath: 'assets/images/border_profile.png',
                          text: username,
                          spacing: 6,
                        ),
                        horizontalIcon(text: id, spacing: 12, textSize: 14),
                        horizontalIcon(
                          imagePath: 'assets/images/country.png',
                          text: "Country:",
                          extraText: country,
                          spacing: 12,
                        ),
                        horizontalIcon(
                          imagePath: 'assets/images/birthdate.png',
                          text: "Birthdate:",
                          extraText: birthDate,
                          spacing: 12,
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
