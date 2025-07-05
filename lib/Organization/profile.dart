import 'package:flutter/material.dart';
import 'package:fypapp2/services/date_converter.dart';
import 'package:fypapp2/widget/icon_box.dart';
import 'package:fypapp2/widget/empty_box.dart';
import '../../services/profile.dart';
import '../widget/app_bar.dart';
import '../widget/horizontal_box.dart';
import '../widget/profile_head.dart';
import 'edit_profile.dart';

class OrganizationProfilePage extends StatefulWidget {
  const OrganizationProfilePage({super.key});

  @override
  State<OrganizationProfilePage> createState() =>
      _OrganizationProfilePageState();
}

class _OrganizationProfilePageState extends State<OrganizationProfilePage> {
  String username = '';
  String id = '';
  String country = '';
  String description = '';
  String address = '';
  String creationDate = '';
  bool isVerified = false;
  String? profileImage;
  String? backgroundImage;
  String? fund;
  List<String> tid = [];
  List<String> type = [];
  bool isLoading = true; // <-- Add loading state

  @override
  void initState() {
    super.initState();
    loadOrganizationProfile();
  }

  Future<void> loadOrganizationProfile() async {
    try {
      final data = await getOrganizationProfile();
      setState(() {
        id = data['ID'].toString();
        username = data['Username'];
        country = data['Country'];
        creationDate = data['CreationDate'];
        profileImage = data['ProfileImage'];
        backgroundImage = data['BackgroundImage'];
        description = data['Description'];
        address = data['Address'];
        isVerified = data['isVerified'];
        fund = data['Fund']?.toString();
        final dynamicTypes = data['TypeName'];
        if (dynamicTypes != null && dynamicTypes is List) {
          type = List<String>.from(dynamicTypes.map((e) => e.toString()));
        } else {
          type = [];
        }
        final dynamicTID = data['TID'];
        if (dynamicTID != null && dynamicTID is List) {
          tid = List<String>.from(dynamicTID.map((e) => e.toString()));
        } else {
          tid = [];
        }

        isLoading = false; // done loading
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.floor();

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // loading spinner
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle first button press
                              },
                              child: Text('View ledger'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Handle second button press
                              },
                              child: Text('Verify account'),
                            ),
                          ],
                        ),
                        gaph16,
                        //add is verified later
                        horizontalIcon(
                          imagePath: 'assets/images/border_profile.png',
                          text: username,
                          spacing: 6,
                        ),
                        horizontalIcon(text: id, textSize: 14, spacing: 12),
                        CustomHorizontalBox(items: type, textSize: 13),
                        gaph12,
                        horizontalIcon(
                          alignment: MainAxisAlignment.start,
                          text: "Description:",
                          extraText: description,
                          spacing: 12,
                        ),
                        horizontalIcon(
                          imagePath: 'assets/images/calendar.png',
                          text: "Joined on:",
                          extraText: formatDate(creationDate),
                          spacing: 12,
                        ),
                        horizontalIcon(
                          imagePath: 'assets/images/country.png',
                          text: "Country of origin:",
                          extraText: country,
                          spacing: 12,
                        ),
                        horizontalIcon(
                          imagePath: 'assets/images/address.png',
                          text: "Address:",
                          extraText: address,
                          spacing: 12,
                        ),
                      ],
                    ),
                  ),
                  gaph24,
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrganizationEditProfile(
                              id: id,
                              username: username,
                              country: country,
                              profileImage: profileImage,
                              backgroundImage: backgroundImage,
                              address: address,
                              description: description,
                              tid: tid,
                            ),
                          ),
                        );
                      },
                      child: Text('Edit Profile'),
                    ),
                  ),
                  gaph24,
                ],
              ),
            ),
    );
  }
}

// isVerified, following
