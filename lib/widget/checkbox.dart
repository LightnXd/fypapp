import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final List<Map<String, String>> types;
  final void Function(List<String> selectedTIDs)? onSelectionChanged;
  final List<String>? initialSelectedTIDs;

  const CustomCheckbox({
    super.key,
    required this.types,
    this.onSelectionChanged,
    this.initialSelectedTIDs,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  final Set<String> selectedTIDs = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedTIDs != null) {
      selectedTIDs.addAll(
        widget.initialSelectedTIDs!.where(
          (tid) => widget.types.any((type) => type['TID'] == tid),
        ),
      );
    }
  }

  void _toggleSelection(String tid) {
    setState(() {
      if (selectedTIDs.contains(tid)) {
        selectedTIDs.remove(tid);
      } else if (selectedTIDs.length < 5) {
        selectedTIDs.add(tid);
      }
    });

    widget.onSelectionChanged?.call(selectedTIDs.toList());
  }

  List<String> get selected => selectedTIDs.toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.types.map((type) {
        final tid = type['TID']!;
        final typeName = type['TypeName']!;
        return CheckboxListTile(
          title: Text(typeName),
          value: selectedTIDs.contains(tid),
          onChanged: (_) => _toggleSelection(tid),
        );
      }).toList(),
    );
  }
}
