import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectionScreen extends StatefulWidget {
  final int userId;

  SelectionScreen({required this.userId});

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  List<dynamic> genders = [];
  List<dynamic> budgets = [];
  List<dynamic> interests = [];

  int? selectedGenderId;
  int? selectedBudgetId;
  int? selectedInterestId;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://giftgenerator.atwebpages.com/getSelectionData.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            genders = data['genders'];
            budgets = data['budgets'];
            interests = data['interests'];
          });
        } else {
          showError(data['message']);
        }
      } else {
        showError('Failed to fetch data');
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  Future<void> saveSelection() async {
    if (selectedGenderId == null || selectedBudgetId == null || selectedInterestId == null) {
      showError('Please select all options!');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://giftgenerator.atwebpages.com/saveSelection.php'),
        body: {
          'user_id': widget.userId.toString(),
          'gender_id': selectedGenderId.toString(),
          'budget_id': selectedBudgetId.toString(),
          'interest_id': selectedInterestId.toString(),
        },
      );

      final data = json.decode(response.body);

      if (data['success']) {
        showSuccess('Selection saved successfully!');
      } else {
        showError(data['message']);
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, style: TextStyle(color: Colors.green))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Make Your Selection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Gender'),
            DropdownButton<int>(
              value: selectedGenderId,
              hint: Text('Choose Gender'),
              onChanged: (value) {
                setState(() {
                  selectedGenderId = value;
                });
              },
              items: genders.map<DropdownMenuItem<int>>((gender) {
                return DropdownMenuItem<int>(
                  value: gender['id'],
                  child: Text(gender['gender_name']),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text('Select Budget'),
            DropdownButton<int>(
              value: selectedBudgetId,
              hint: Text('Choose Budget'),
              onChanged: (value) {
                setState(() {
                  selectedBudgetId = value;
                });
              },
              items: budgets.map<DropdownMenuItem<int>>((budget) {
                return DropdownMenuItem<int>(
                  value: budget['id'],
                  child: Text(budget['amount']),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text('Select Interest'),
            DropdownButton<int>(
              value: selectedInterestId,
              hint: Text('Choose Interest'),
              onChanged: (value) {
                setState(() {
                  selectedInterestId = value;
                });
              },
              items: interests.map<DropdownMenuItem<int>>((interest) {
                return DropdownMenuItem<int>(
                  value: interest['id'],
                  child: Text(interest['interest_name']),
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: saveSelection,
              child: Text('Save Selection'),
            ),
          ],
        ),
      ),
    );
  }
}
