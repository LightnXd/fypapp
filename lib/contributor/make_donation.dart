import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fypapp2/services/url.dart';
import 'package:fypapp2/widget/app_bar.dart';
import 'package:fypapp2/widget/empty_box.dart';
import 'package:fypapp2/widget/horizontal_box.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/authentication.dart';
import '../services/transaction.dart';

class MakeDonationPage extends StatefulWidget {
  final String oid;

  const MakeDonationPage({Key? key, required this.oid}) : super(key: key);

  @override
  State<MakeDonationPage> createState() => _MakeDonationPageState();
}

class _MakeDonationPageState extends State<MakeDonationPage> {
  bool isLoading = false;
  late bool isRegistered;
  double amount = 0.00;
  final AuthenticationService _authService = AuthenticationService();
  String? cid;

  @override
  void initState() {
    super.initState();
    _initStripe();
  }

  Future<void> _initStripe() async {
    final publishableKey = await getPublicKey(widget.oid);
    try {
      if (publishableKey == null || publishableKey.isEmpty) {
        isRegistered = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The organization have not enable donation!"),
          ),
        );
        return;
      }

      Stripe.publishableKey = publishableKey!;
      await Stripe.instance.applySettings();
    } catch (e) {
      isRegistered = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Organization donation information is invalid"),
        ),
      );
    }
  }

  Future<void> _startPayment() async {
    setState(() => isLoading = true);

    try {
      final cid = await _authService.getCurrentUserID();
      if (cid == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Unable to find user ID')));
        return;
      }

      int donate = (amount * 100).toInt();

      final clientSecret = await makeDonation(donate, "myr", widget.oid);
      if (clientSecret == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to get client secret")),
        );
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: widget.oid,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      try {
        await changeFund(oid: widget.oid, amount: amount, type: true);

        final response = await http.post(
          Uri.parse(addBlockUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'OID': widget.oid, 'Amount': amount, 'CID': cid}),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 && data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Transaction successful. LedgerID: ${data['LedgerID']}',
              ),
            ),
          );
        } else {
          throw Exception(data['error'] ?? 'Transaction failed');
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Payment successful!")));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment cancelled: ${e.error.localizedMessage}"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Make Donation"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                gaph60,
                Text(
                  'RM ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                gaph60,
                HorizontalBox3(
                  leftText: '5',
                  midText: '10',
                  rightText: '20',
                  textSize: 20,
                  width: 90,
                  color3: Color(0xFFBAFFC9),
                  color2: Color(0xFFBAFFC9),
                  onLeftTap: () => setState(() => amount = 5.00),
                  onMidTap: () => setState(() => amount = 10.00),
                  onRightTap: () => setState(() => amount = 20.00),
                ),
                gaph40,
                HorizontalBox3(
                  leftText: '50',
                  midText: '100',
                  rightText: '200',
                  textSize: 20,
                  width: 90,
                  color3: Color(0xFFBAFFC9),
                  color2: Color(0xFFBAFFC9),
                  onLeftTap: () => setState(() => amount = 50.00),
                  onMidTap: () => setState(() => amount = 100.00),
                  onRightTap: () => setState(() => amount = 200.00),
                ),
                gaph60,
                gaph20,
                ElevatedButton(
                  onPressed: amount >= 5.00
                      ? _startPayment
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "The minimum donation amount is 5 Ringgit",
                              ),
                            ),
                          );
                        },
                  child: const Text(
                    "Make Donation",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
    );
  }
}
