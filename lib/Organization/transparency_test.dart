import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fypapp2/widget/app_bar.dart';

import '../services/charity_transparency_framework_question.dart';
import '../widget/checkbox.dart';
import '../widget/empty_box.dart';

class TransparentTestPage extends StatefulWidget {
  const TransparentTestPage({Key? key}) : super(key: key);

  @override
  _TransparentTestPageState createState() => _TransparentTestPageState();
}

class _TransparentTestPageState extends State<TransparentTestPage> {
  String _currentType = 'Basic';
  List<String> _selectedIds = [];
  double? _score;

  List<Map<String, String>> get _questions {
    switch (_currentType) {
      case 'Intermediate':
        return Intermediate;
      case 'Advance':
        return Advance;
      default:
        return Basic;
    }
  }

  void _onTypeChanged(String? newType) {
    if (newType == null) return;
    setState(() {
      _currentType = newType;
      _selectedIds.clear();
      _score = null;
    });
  }

  void _onSelectionChanged(List<String> ids) {
    setState(() {
      _selectedIds = ids;
    });
  }

  void _calculateScore() {
    final total = _questions.length;
    final selected = _selectedIds.length;
    setState(() {
      _score = total > 0 ? (selected / total * 100) : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Charity Transparency Framework Test'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: DropdownButton<String>(
                value: _currentType,
                items: const [
                  DropdownMenuItem(value: 'Basic', child: Text('Basic')),
                  DropdownMenuItem(
                    value: 'Intermediate',
                    child: Text('Intermediate'),
                  ),
                  DropdownMenuItem(value: 'Advance', child: Text('Advance')),
                ],
                onChanged: _onTypeChanged,
              ),
            ),
            gaph16,
            Center(
              child: Text(
                '${_currentType.toString()} Charity Framework Test',
                style: TextStyle(fontSize: 20),
              ),
            ),
            gaph24,
            Text(
              'Check if the statement true:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            gaph10,
            CustomCheckbox(
              types: _questions,
              idKey: 'index',
              labelKey: 'question',
              initialSelectedIds: const [],
              onSelectionChanged: _onSelectionChanged,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateScore,
              child: const Text('Calculate Score'),
            ),
            gaph16,
            if (_score != null)
              Center(
                child: Text(
                  'Your Organization Transparency Score is = ${_score!.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            gaph32,
          ],
        ),
      ),
    );
  }
}
