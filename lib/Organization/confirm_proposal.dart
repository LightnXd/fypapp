import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fypapp2/services/date_converter.dart';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;
import '../services/transaction.dart';
import '../widget/app_bar.dart';
import '../widget/empty_box.dart';
import '../widget/icon_box.dart';

class ConfirmProposalPage extends StatefulWidget {
  final String proposalid;
  final String oid;
  final String name;
  final String image;
  final String title;
  final String description;
  final String amount;
  final String creationDate;
  final String limit;
  final String status;
  final String yes;
  final String no;
  final String notVoted;

  const ConfirmProposalPage({
    super.key,
    required this.proposalid,
    required this.oid,
    required this.name,
    required this.image,
    required this.title,
    required this.description,
    required this.amount,
    required this.creationDate,
    required this.limit,
    required this.status,
    required this.yes,
    required this.no,
    required this.notVoted,
  });

  @override
  State<ConfirmProposalPage> createState() => _ConfirmProposalPageState();
}

class _ConfirmProposalPageState extends State<ConfirmProposalPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSending = false;

  Future<void> changeStatus(BuildContext context, String change) async {
    try {
      final result = await changeProposalStatus(
        proposalid: widget.proposalid,
        status: change,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Proposal successfully $change')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to change status: $e')));
    }
  }

  Future<void> _sendTransaction(BuildContext context) async {
    setState(() => _isSending = true);
    try {
      await changeStatus(context, "Confirmed");

      final response = await http.post(
        Uri.parse(addBlockUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'OID': widget.oid, 'Amount': widget.amount}),
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
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _cancelTransaction(BuildContext context) async {
    setState(() => _isSending = true);
    try {
      await changeStatus(context, "Cancelled"); // ✅ await it
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == 'Confirmed' || widget.status == 'Cancelled') {
      return Scaffold(
        appBar: CustomAppBar(title: 'Transaction ${widget.status}'),
        body: Center(
          child: Text(
            'Transaction ${widget.status}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: 'Confirm Transaction', type: 2),
      body: _isSending
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    gaph40,
                    Center(
                      // Centers the CircleAvatar horizontally
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            (widget.image.isNotEmpty &&
                                widget.image.startsWith('http'))
                            ? NetworkImage(widget.image)
                            : const AssetImage('assets/images/profile.png')
                                  as ImageProvider,
                      ),
                    ),
                    gaph10,
                    horizontalIcon(text: widget.name, spacing: 4, textSize: 20),
                    horizontalIcon(text: widget.oid, spacing: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          horizontalIcon(
                            text: 'Title:',
                            extraText: widget.title,
                            spacing: 16,
                          ),
                          horizontalIcon(
                            text: 'Fund used:',
                            extraText: widget.amount,
                            spacing: 16,
                          ),
                          horizontalIcon(
                            text: 'Creation date:',
                            extraText: formatDate(widget.creationDate),
                            spacing: 16,
                          ),
                          horizontalIcon(
                            text: 'Yes vote:',
                            extraText: widget.description,
                            spacing: 16,
                          ),
                          horizontalIcon(
                            text: 'No vote:',
                            extraText: widget.description,
                            spacing: 16,
                          ),
                          horizontalIcon(
                            text: 'Have not vote:',
                            extraText: widget.description,
                            spacing: 16,
                          ),
                          horizontalIcon(
                            text: 'Remaining time to vote:',
                            extraText: widget.limit,
                            spacing: 16,
                          ),
                          horizontalIcon(
                            text: 'Description:',
                            extraText: widget.description,
                            spacing: 40,
                          ),
                        ],
                      ),
                    ),
                    if (widget.status == 'Waiting')
                      ElevatedButton(
                        onPressed: _isSending
                            ? null
                            : () => _sendTransaction(context),
                        child: _isSending
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Create Transaction'),
                      ),
                    if (widget.status == 'Waiting') const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isSending
                          ? null
                          : () => _cancelTransaction(context),
                      child: _isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('Cancel Transaction ${widget.oid}'),
                    ),
                    gaph40,
                  ],
                ),
              ),
            ),
    );
  }
}
