import 'package:flutter/material.dart';
import 'package:fypapp2/services/date_converter.dart';
import 'package:fypapp2/widget/icon_box.dart';
import 'package:fypapp2/widget/empty_box.dart';
import '../../services/profile.dart';
import '../contributor/ledger_list.dart';
import '../services/transaction.dart';
import '../widget/app_bar.dart';
import '../widget/horizontal_box.dart';
import '../widget/profile_head.dart';
import '../widget/question_box.dart';
import '../widget/response_dialog.dart';
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
  bool isLoading = true;
  final publicController = TextEditingController();
  final secretController = TextEditingController();
  String? publicError;
  String? secretError;

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

        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      showDialog(
        context: context,
        builder: (context) =>
            ResponseDialog(title: 'Error', message: 'Error: $e', type: false),
      );
    }
  }

  bool validateInputs() {
    final confirmPublic = publicController.text;
    final confirmSecret = secretController.text;

    setState(() {
      publicError = confirmPublic.isNotEmpty
          ? null
          : 'Country must not be empty';
      secretError = confirmSecret.isNotEmpty
          ? null
          : 'Address must not be empty';
    });

    return confirmPublic.isNotEmpty && confirmSecret.isNotEmpty;
  }

  void dispose() {
    publicController.dispose();
    secretController.dispose();
    super.dispose();
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
                            ElevatedButton(
                              onPressed: _showWalletConfigModal,
                              child: Text('Wallet Details'),
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

  void _showWalletConfigModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Text(
                  'Input your Stripe information?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                gaph28,
                QuestionBox(
                  label: 'Public key:',
                  hint: 'Enter your Stripe public key',
                  controller: publicController,
                  errorText: publicError,
                ),
                QuestionBox(
                  label: 'Secret key:',
                  hint: 'Enter your Stripe secret key',
                  controller: secretController,
                  errorText: secretError,
                ),
                gaph32,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        publicController.clear();
                        secretController.clear();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        _changeKey(
                          publicController.text,
                          secretController.text,
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Confirm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _changeKey(String public, String secret) async {
    if (!validateInputs()) return;
    try {
      final message = await changeOrganizationKey(
        oid: id,
        publicKey: public.trim(),
        secretKey: secret.trim(),
      );
      publicController.clear();
      secretController.clear();
      showDialog(
        context: context,
        builder: (context) =>
            ResponseDialog(title: 'Success', message: message, type: true),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => ResponseDialog(
          title: 'Error',
          message: 'Unexpected error: $e',
          type: false,
        ),
      );
    }
  }
}
