import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerDropdown extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final DateTime firstDate;
  final DateTime initialDate;
  final DateTime lastDate;

  DatePickerDropdown({
    super.key,
    required this.hint,
    required this.controller,
    DateTime? firstDate,
    DateTime? initialDate,
    DateTime? lastDate,
  }) : firstDate = firstDate ?? DateTime(1900),
       initialDate =
           initialDate ??
           DateTime(
             DateTime.now().year - 12,
             DateTime.now().month,
             DateTime.now().day,
           ),
       lastDate =
           lastDate ??
           DateTime(
             DateTime.now().year - 12,
             DateTime.now().month,
             DateTime.now().day,
           );

  @override
  Widget build(BuildContext context) {
    print(lastDate);
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
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

DateTime daysLater(int days) {
  return DateTime.now().add(Duration(days: days));
}
