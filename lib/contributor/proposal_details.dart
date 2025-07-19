import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fypapp2/services/date_converter.dart';
import 'package:fypapp2/services/url.dart';
import 'package:http/http.dart' as http;
import '../services/transaction.dart';
import '../widget/app_bar.dart';
import '../widget/empty_box.dart';
import '../widget/horizontal_box.dart';
import '../widget/icon_box.dart';

class ProposalDetailsPage extends StatefulWidget {
  final String cid;
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
  final bool isHistory;

  const ProposalDetailsPage({
    super.key,
    required this.cid,
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
    required this.isHistory,
  });

  @override
  State<ProposalDetailsPage> createState() => _ProposalDetailsPageState();
}

class _ProposalDetailsPageState extends State<ProposalDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSending = false;
  bool? vote;
  bool isSuccess = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVote();
  }

  Future<void> refresh() async {
    _fetchVote();
  }

  Future<void> _fetchVote() async {
    print(widget.cid);
    setState(() {
      isLoading = true;
    });
    try {
      final data = await getVote(
        proposalId: widget.proposalid,
        cid: widget.cid,
      );

      setState(() {
        vote = data['vote'];
        isSuccess = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        vote = null;
        isSuccess = false;
        isLoading = false;
      });
    }
  }

  Future<void> _castVote(BuildContext context, bool vote) async {
    setState(() => _isSending = true);
    try {
      await castVote(
        proposalid: widget.proposalid,
        cid: widget.cid,
        vote: vote,
      );
      await _fetchVote();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit vote: $e')));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: 'Confirm Transaction', type: 2),
      body: _isSending || isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: refresh,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    children: [
                      gaph40,
                      Center(
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
                      horizontalIcon(
                        text: widget.name,
                        spacing: 4,
                        textSize: 20,
                      ),
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
                              spacing: 150,
                            ),
                          ],
                        ),
                      ),
                      if (vote == null && isSuccess && !widget.isHistory) ...[
                        ElevatedButton(
                          onPressed: _isSending
                              ? null
                              : () => _castVote(context, true),
                          child: _isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Vote Yes'),
                        ),
                        gaph20,
                        ElevatedButton(
                          onPressed: _isSending
                              ? null
                              : () => _castVote(context, false),
                          child: _isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Vote No'),
                        ),
                      ],
                      if (vote == true)
                        BuildingBox(
                          text: "Voted Yes",
                          textSize: 16,
                          width: 150,
                        ),
                      if (vote == false)
                        BuildingBox(
                          text: "Voted No",
                          textSize: 16,
                          color: Color(0xFFFF8A8A),
                          width: 150,
                        ),
                      if (!isSuccess && !widget.isHistory)
                        BuildingBox(
                          text: "Not eligible to vote",
                          textSize: 16,
                          color: Color(0xFFE9E9E9),
                          width: 250,
                        ),
                      gaph40,
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
