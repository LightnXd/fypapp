import 'package:flutter/material.dart';
import 'package:fypapp2/widget/app_bar.dart';
import '../services/authentication.dart';
import '../services/transaction.dart';
import '../widget/date_picker.dart';
import '../widget/empty_box.dart';
import '../widget/question_box.dart';
import '../widget/response_dialog.dart';
import '../widget/side_bar.dart';

class CreateProposalPage extends StatefulWidget {
  const CreateProposalPage({super.key});

  @override
  State<CreateProposalPage> createState() => _CreateProposalPageState();
}

class _CreateProposalPageState extends State<CreateProposalPage> {
  final AuthenticationService _authService = AuthenticationService();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final birthdateController = TextEditingController();
  String? oid;
  bool isLoading = false;

  String? titleError;
  String? descriptionError;
  String? amountError;
  String? dateError;

  Future<void> _submitProposal() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    String amountText = amountController.text.trim();
    String birthdate = birthdateController.text.trim();
    final DateTime parsedDate = DateTime.parse(birthdate);
    final amount = double.tryParse(amountText);

    setState(() {
      titleError = title.length >= 5
          ? null
          : 'Title must be at least 5 characters';
      descriptionError = description.length >= 25
          ? null
          : 'Description must be at least 25 characters';
      amountError = (amount != null && amount > 0)
          ? null
          : 'Amount must be greater than 0';
      dateError = birthdate.isNotEmpty ? null : 'Please select a date';
    });

    final isValid =
        titleError == null &&
        descriptionError == null &&
        amountError == null &&
        dateError == null;

    if (isValid && amount != null) {
      setState(() => isLoading = true);
      try {
        final getOID = await _authService.getCurrentUserID();
        if (getOID == null) {
          throw Exception('User ID (oid) is null');
        }
        setState(() => oid = getOID);
        await createProposalRequest(
          oid: getOID,
          title: title,
          description: description,
          amount: amount,
          endDate: parsedDate.toUtc().toString(),
        );
        showDialog(
          context: context,
          builder: (context) => ResponseDialog(
            title: 'Success',
            message: 'Proposal created successfully',
            type: true,
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => ResponseDialog(
            title: 'Error',
            message: 'Failed to create proposal: $e',
            type: false,
          ),
        );
      }
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Proposal', type: 1),
      drawerEnableOpenDragGesture: false,
      drawer: oid == null ? null : OrganizationSideBar(userId: oid!),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            QuestionBox(
              controller: titleController,
              label: 'Title',
              hint: 'Enter the title',
              errorText: titleError,
            ),
            QuestionBox(
              keyboardType: TextInputType.number,
              label: 'Amount',
              hint: 'Enter amount',
              controller: amountController,
              errorText: amountError,
            ),
            QuestionBox(
              label: 'Description:',
              hint: 'Description',
              maxline: 10,
              controller: descriptionController,
              errorText: descriptionError,
            ),
            DatePickerDropdown(
              hint: 'Select the proposal end date',
              controller: birthdateController,
              firstDate: daysLater(30), // 1 month later
              initialDate: daysLater(30), // 1 month later
              lastDate: DateTime(2200),
            ),
            gaph32,
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitProposal,
                    child: const Text('Submit Proposal'),
                  ),
          ],
        ),
      ),
    );
  }
}
