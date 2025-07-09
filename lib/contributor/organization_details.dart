import 'package:flutter/material.dart';
import 'package:fypapp2/contributor/make_donation.dart';
import 'package:fypapp2/services/date_converter.dart';
import 'package:fypapp2/widget/icon_box.dart';
import 'package:fypapp2/widget/empty_box.dart';
import '../../services/profile.dart';
import '../services/authentication.dart';
import '../services/follow.dart';
import '../widget/app_bar.dart';
import '../widget/horizontal_box.dart';
import '../widget/profile_head.dart';
import 'ledger.dart';

class OrganizationDetailsPage extends StatefulWidget {
  final String oid;
  const OrganizationDetailsPage({super.key, required this.oid});

  @override
  State<OrganizationDetailsPage> createState() =>
      _OrganizationDetailsPageState();
}

class _OrganizationDetailsPageState extends State<OrganizationDetailsPage> {
  final AuthenticationService _authService = AuthenticationService();
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
  bool isLoading = true;
  bool isFollowed = false;
  String? cid;
  int count = 0;
  @override
  void initState() {
    super.initState();
    loadCount();
    loadOrganizationProfile();
  }

  Future<void> loadCount() async {
    final result = await fetchCountByOID(widget.oid);
    setState(() {
      count = result!;
    });
  }

  Future<void> loadOrganizationProfile() async {
    try {
      final data = await getOrganizationProfile(oid: widget.oid);
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
      });
      final getcid = await _authService.getCurrentUserID();
      final followed = await isFollowing(widget.oid, getcid!);
      setState(() {
        isFollowed = followed;
        cid = getcid;
        isLoading = false;
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
      appBar: CustomAppBar(title: 'Organization Details'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // loading spinner
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProfileHeader(
                    profileUrl: profileImage,
                    backgroundUrl: backgroundImage,
                    follower: "",
                  ),

                  SizedBox(height: screenWidth / 5.3),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (cid == null) return;

                              bool success = isFollowed
                                  ? await unfollowOrganization(widget.oid, cid!)
                                  : await followOrganization(widget.oid, cid!);

                              if (success) {
                                loadCount();
                                setState(() {
                                  isFollowed = !isFollowed;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFollowed
                                          ? 'Followed successfully'
                                          : 'Unfollowed successfully',
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Something went wrong.'),
                                  ),
                                );
                              }
                            },
                            child: Text(isFollowed ? 'Unfollow' : 'Follow'),
                          ),
                        ),
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
                          spacing: 24,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ContributorLedgerPage(oid: id),
                                ),
                              );
                            },
                            child: Text('View ledger'),
                          ),
                        ),
                        gaph24,
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MakeDonationPage(oid: id),
                                ),
                              );
                            },
                            child: Text('Make Donation'),
                          ),
                        ),
                      ],
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
