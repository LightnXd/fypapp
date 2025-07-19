import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fypapp2/services/url.dart';
import 'package:fypapp2/widget/app_bar.dart';
import 'package:fypapp2/widget/empty_box.dart';
import 'package:fypapp2/widget/horizontal_box.dart';
import 'package:fypapp2/widget/question_box.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/authentication.dart';
import '../services/transaction.dart';
import '../widget/response_dialog.dart';

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
  final customAmountController = TextEditingController();
  String? customAmountError;

  @override
  void initState() {
    super.initState();
    _initStripe();
  }

  @override
  Future<void> _initStripe() async {
    final publishableKey = await getPublicKey(widget.oid);
    try {
      if (publishableKey == null || publishableKey.isEmpty) {
        isRegistered = false;
        showDialog(
          context: context,
          builder: (context) => ResponseDialog(
            title: 'Wallet not Found',
            message:
                'The organization have not set up their wallet information yet',
            type: false,
          ),
        );
        return;
      }

      Stripe.publishableKey = publishableKey!;
      await Stripe.instance.applySettings();
    } catch (e) {
      isRegistered = false;
      showDialog(
        context: context,
        builder: (context) => ResponseDialog(
          title: 'Invalid Wallet',
          message: "Organization wallet information is invalid",
          type: false,
        ),
      );
    }
  }

  Future<void> _startPayment() async {
    setState(() => isLoading = true);

    try {
      final cid = await _authService.getCurrentUserID();
      if (cid == null) {
        showDialog(
          context: context,
          builder: (context) => ResponseDialog(
            title: 'Transaction Failed',
            message: ' Unable to get your information',
            type: false,
          ),
        );
        return;
      }

      int donate = (amount * 100).toInt();
      final clientSecret = await makeDonation(donate, "myr", widget.oid);
      if (clientSecret == null) {
        showDialog(
          context: context,
          builder: (context) => ResponseDialog(
            title: 'Transaction Failed',
            message: "Failed to get client secret",
            type: false,
          ),
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
          showDialog(
            context: context,
            builder: (context) => ResponseDialog(
              title: 'Transaction Successful',
              message:
                  'Transaction saved to the ledger with LedgerID: ${data['LedgerID']}',
              type: true,
            ),
          );
        } else {
          throw Exception(data['error'] ?? 'Transaction failed');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => ResponseDialog(
            title: 'Payment Failed',
            message: "Error: $e",
            type: false,
          ),
        );
      }
    } on StripeException catch (e) {
      showDialog(
        context: context,
        builder: (context) => ResponseDialog(
          title: 'Payment Cancelled',
          message:
              e.error.localizedMessage ??
              "Unable to get the reason of this exception",
          type: false,
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => ResponseDialog(
          title: 'An unexpected error occur',
          message: "Error: $e",
          type: false,
        ),
      );
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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                    gaph20,
                    QuestionBox(
                      label: "Custom Donation",
                      hint: "Enter the amount eg(20.50)",
                      controller: customAmountController,
                      keyboardType: TextInputType.number,
                      errorText: customAmountError,
                    ),
                    gaph60,
                    gaph20,
                    ElevatedButton(
                      onPressed: () {
                        final textValue = customAmountController.text;
                        final parsed = double.tryParse(textValue) ?? 0.0;

                        if (parsed >= 5.00) {
                          setState(() {
                            amount = parsed;
                          });
                          _startPayment();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => ResponseDialog(
                              title: 'Invalid Amount',
                              message:
                                  'The inputted amount is invalid or under RM 5.00',
                              type: false,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Make a Custom Donation",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    gaph32,
                    ElevatedButton(
                      onPressed: amount >= 5.00
                          ? _startPayment
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => ResponseDialog(
                                  title: 'Invalid Amount',
                                  message:
                                      'The minimum donation amount is RM 5',
                                  type: false,
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
              ),
            ),
    );
  }
}
