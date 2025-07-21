import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final List<Map<String, String>> types;
  final void Function(List<String> selectedIds)? onSelectionChanged;
  final List<String>? initialSelectedIds;
  final int? maxSelection;
  final String idKey;
  final String labelKey;

  const CustomCheckbox({
    super.key,
    required this.types,
    this.onSelectionChanged,
    this.initialSelectedIds,
    this.maxSelection,
    this.idKey = 'TID',
    this.labelKey = 'TypeName',
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedIds != null) {
      _selectedIds.addAll(
        widget.initialSelectedIds!.where(
          (id) => widget.types.any((m) => m[widget.idKey] == id),
        ),
      );
    }
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        if (widget.maxSelection == null ||
            _selectedIds.length < widget.maxSelection!) {
          _selectedIds.add(id);
        }
      }
    });
    widget.onSelectionChanged?.call(_selectedIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.types.map((item) {
        final id = item[widget.idKey]!;
        final label = item[widget.labelKey]!;
        return CheckboxListTile(
          title: Text(label),
          value: _selectedIds.contains(id),
          onChanged: (_) => _toggleSelection(id),
        );
      }).toList(),
    );
  }
}
