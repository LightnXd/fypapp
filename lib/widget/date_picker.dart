import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerDropdown extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const DatePickerDropdown({
    super.key,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }
}
