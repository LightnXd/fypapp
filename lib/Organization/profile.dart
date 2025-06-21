import 'package:flutter/material.dart';
import 'package:fypapp2/widget/icon_box.dart';
import 'package:fypapp2/widget/empty_box.dart';
import '../../services/profile.dart';
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
  String? walletAddress;
  String? walletBalance;

  bool isLoading = true; // <-- Add loading state

  @override
  void initState() {
    super.initState();
    // Uncomment this when testing with real data
    // loadOrganizationProfile();
  }

  Future<void> loadOrganizationProfile() async {
    try {
      final data = await fetchOrganizationProfile();
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
        walletAddress = data['WalletAddress'];
        walletBalance = data['WalletBalance']?.toString();
        isLoading = false; // done loading
      });
    } catch (e) {
      setState(() => isLoading = false); // also stop loading on error
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
          '<  Organization profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle first button press
                        },
                        child: Text('Button 1'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle second button press
                        },
                        child: Text('Button 2'),
                      ),
                    ],
                  ),
                  gaph16,
                  CustomHorizontalBox(
                    items: ['Alice', 'Bob', 'Charlie', 'David'],
                  ),
                  gaph16,
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
                  //3icon
                  gaph12,
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    softWrap: true,
                  ),
                  gaph12,
                  horizontalIcon(
                    imagePath: 'assets/images/test.webp',
                    text: creationDate,
                    spacing: 12,
                  ),
                  horizontalIcon(
                    imagePath: 'assets/images/test.webp',
                    text: country,
                    spacing: 12,
                  ),
                  horizontalIcon(
                    imagePath: 'assets/images/test.webp',
                    text: address,
                    spacing: 12,
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
