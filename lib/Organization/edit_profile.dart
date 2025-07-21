import 'package:flutter/material.dart';
import '../../services/profile.dart';
import '../../widget/profile_head.dart';
import '../../widget/question_box.dart';
import '../services/authentication.dart';
import '../widget/app_bar.dart';
import '../widget/checkbox.dart';
import '../widget/dropdown_label.dart';
import '../widget/empty_box.dart';
import '../widget/response_dialog.dart';

class OrganizationEditProfile extends StatefulWidget {
  final String id;
  final String username;
  final String address;
  final String description;
  final String country;
  final String? profileImage;
  final String? backgroundImage;
  final List<String> tid;

  const OrganizationEditProfile({
    super.key,
    required this.id,
    required this.username,
    required this.address,
    required this.description,
    required this.country,
    this.profileImage,
    this.backgroundImage,
    required this.tid,
  });

  @override
  State<OrganizationEditProfile> createState() =>
      _OrganizationEditProfileState();
}

class _OrganizationEditProfileState extends State<OrganizationEditProfile> {
  final AuthenticationService _authService = AuthenticationService();
  late TextEditingController nameController;
  late TextEditingController countryController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;
  List<String> selectedTID = [];
  List<Map<String, String>> organizationTypes = [];
  bool isLoading = true;

  String? nameError;
  String? countryError;
  String? addressError;
  String? descriptionError;
  String? typeError;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.username);
    countryController = TextEditingController(text: widget.country);
    addressController = TextEditingController(text: widget.address);
    descriptionController = TextEditingController(text: widget.description);
    selectedTID = List.from(widget.tid);
    loadTypes();
  }

  Future<void> loadTypes() async {
    try {
      final types = await _authService.getOrganizationTypes();
      setState(() {
        organizationTypes = types;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    addressController.dispose();
    descriptionController.dispose();
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
      typeError = selectedTID.isNotEmpty
          ? null
          : 'At least 1 type must be selected';
    });

    return nameError == null &&
        countryError == null &&
        addressError == null &&
        descriptionError == null &&
        typeError == null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.floor();
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Profile'),
      body: isLoading
          ? Center(child: const CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeader(
                    profileUrl: widget.profileImage,
                    backgroundUrl: widget.backgroundImage,
                  ),
                  SizedBox(height: screenWidth / 4.3),
                  QuestionBox(
                    label: 'Name:',
                    hint: 'Enter your name',
                    controller: nameController,
                    errorText: nameError,
                  ),
                  DropdownLabel(
                    label: "Change your types",
                    textColor: Colors.black,
                    errorText: typeError,
                    onPressed: () {
                      showCheckboxDialog(context);
                    },
                  ),
                  QuestionBox(
                    label: 'Country:',
                    hint: 'Enter your country',
                    controller: countryController,
                    errorText: countryError,
                  ),
                  QuestionBox(
                    label: 'Address:',
                    hint: 'Enter your address',
                    controller: addressController,
                    errorText: addressError,
                  ),
                  QuestionBox(
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
                          showDialog(
                            context: context,
                            builder: (context) => ResponseDialog(
                              title: 'Success',
                              message: 'Profile updated successfully',
                              type: true,
                            ),
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            '/organization-main',
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => ResponseDialog(
                              title: 'Failed',
                              message: 'Failed to update profile',
                              type: false,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                  gaph32,
                ],
              ),
            ),
    );
  }

  void showCheckboxDialog(BuildContext context) {
    List<String> tempSelected = List.from(selectedTID);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Select Organization Types"),
        content: SingleChildScrollView(
          child: CustomCheckbox(
            types: organizationTypes,
            initialSelectedIds: tempSelected,
            onSelectionChanged: (selected) {
              tempSelected = selected;
            },
            maxSelection: 5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => selectedTID = tempSelected);
              Navigator.pop(context);
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
