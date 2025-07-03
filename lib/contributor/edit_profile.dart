import 'package:flutter/material.dart';
import 'package:fypapp2/widget/app_bar.dart';
import '../services/profile.dart';
import '../widget/empty_box.dart';
import '../widget/profile_head.dart';
import '../widget/question_box.dart';

class ContributorEditProfile extends StatefulWidget {
  final String id;
  final String username;
  final String country;
  final String? profileImage;
  final String? backgroundImage;

  const ContributorEditProfile({
    super.key,
    required this.id,
    required this.username,
    required this.country,
    this.profileImage,
    this.backgroundImage,
  });

  @override
  State<ContributorEditProfile> createState() => _ContributorEditProfileState();
}

class _ContributorEditProfileState extends State<ContributorEditProfile> {
  late TextEditingController nameController;
  late TextEditingController countryController;

  String? nameError;
  String? countryError;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.username);
    countryController = TextEditingController(text: widget.country);
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    super.dispose();
  }

  bool validateInputs() {
    final name = nameController.text;
    final country = countryController.text;

    setState(() {
      nameError = name.length >= 5
          ? null
          : 'Name must be at least 5 characters';
      countryError = country.isNotEmpty ? null : 'Country is required';
    });

    return nameError == null && countryError == null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.floor();
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              profileUrl: widget.profileImage,
              backgroundUrl: widget.backgroundImage,
            ),
            SizedBox(height: screenWidth / 4.3),

            Padding(
              padding: const EdgeInsets.only(left: 16, right: 30),
              child: Column(
                children: [
                  QuestionBox(
                    label: 'Name:',
                    hint: 'Enter your name',
                    controller: nameController,
                    errorText: nameError,
                  ),
                  QuestionBox(
                    label: 'Country:',
                    hint: 'Enter your country',
                    controller: countryController,
                    errorText: countryError,
                  ),
                ],
              ),
            ),
            gaph32,
            ElevatedButton(
              onPressed: () async {
                if (validateInputs()) {
                  final success = await editContributorProfile(
                    id: widget.id,
                    username: nameController.text,
                    country: countryController.text,
                  );
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update profile')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
