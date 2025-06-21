import 'package:flutter/material.dart';
import '../../services/profile.dart';
import '../../widget/profile_head.dart';
import '../../widget/question_box.dart';
import '../widget/empty_box.dart';

class OrganizationEditProfile extends StatefulWidget {
  final String id;
  final String username;
  final String address;
  final String description;
  final String country;
  final String? profileImage;
  final String? backgroundImage;

  const OrganizationEditProfile({
    super.key,
    required this.id,
    required this.username,
    required this.address,
    required this.description,
    required this.country,
    this.profileImage,
    this.backgroundImage,
  });

  @override
  State<OrganizationEditProfile> createState() =>
      _OrganizationEditProfileState();
}

class _OrganizationEditProfileState extends State<OrganizationEditProfile> {
  late TextEditingController nameController;
  late TextEditingController countryController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;

  String? nameError;
  String? countryError;
  String? addressError;
  String? descriptionError;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.username);
    countryController = TextEditingController(text: widget.country);
    addressController = TextEditingController(text: widget.address);
    descriptionController = TextEditingController(text: widget.description);
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
    final address = addressController.text;
    final description = descriptionController.text;

    setState(() {
      nameError = name.length >= 5
          ? null
          : 'Name must be at least 5 characters';
      countryError = country.isNotEmpty ? null : 'Country is required';
      addressError = address.isNotEmpty ? null : 'Address is required';
      descriptionError = description.isNotEmpty
          ? null
          : 'Description is required';
    });

    return nameError == null &&
        countryError == null &&
        addressError == null &&
        descriptionError == null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.floor();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              profileUrl: widget.profileImage,
              backgroundUrl: widget.backgroundImage,
            ),
            SizedBox(height: screenWidth / 4.3),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Name:',
              hint: 'Enter your name',
              controller: nameController,
              errorText: nameError,
            ),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Country:',
              hint: 'Enter your country',
              controller: countryController,
              errorText: countryError,
            ),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Address:',
              hint: 'Enter your address',
              controller: addressController,
              errorText: addressError,
            ),
            QuestionBox(
              image: const AssetImage('assets/images/test.webp'),
              label: 'Description:',
              hint: 'Enter your description',
              controller: descriptionController,
              errorText: descriptionError,
            ),
            gaph24,
            ElevatedButton(
              onPressed: () async {
                if (validateInputs()) {
                  final success = await editOrganizationProfile(
                    id: widget.id,
                    username: nameController.text,
                    country: countryController.text,
                    address: addressController.text,
                    description: descriptionController.text,
                  );

                  if (success) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully'),
                      ),
                    );
                  } else {
                    // Show error message
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
