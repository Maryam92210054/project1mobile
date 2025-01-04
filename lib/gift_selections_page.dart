import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'gift.dart';
import 'gift_suggestion_page.dart';

class Budget {
  final String id;
  final String amount;

  Budget({required this.id, required this.amount});

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(id: json['id'], amount: json['amount']);
  }
}

class Gender {
  final String id;
  final String genderName;

  Gender({required this.id, required this.genderName});

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(id: json['id'], genderName: json['gender_name']);
  }
}

class Interest {
  final String id;
  final String interestName;
  final String genderId;

  Interest({required this.id, required this.interestName, required this.genderId});

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'],
      interestName: json['interest_name'],
      genderId: json['gender_id'],
    );
  }
}

class GiftSelectionPage extends StatefulWidget {
  @override
  _GiftSelectionPageState createState() => _GiftSelectionPageState();
}

class _GiftSelectionPageState extends State<GiftSelectionPage> {
  String? selectedBudget;
  String? selectedGender;
  String? selectedInterest;

  List<Budget> classBudgets = [];
  List<Gender> classGenders = [];
  List<Interest> classInterests = [];
  List<Interest> filteredInterests = [];

  @override
  void initState() {
    super.initState();
    fetchSelectionData();
  }

  Future<void> fetchSelectionData() async {
    try {
      final response = await http.get(Uri.parse('http://giftgenerator.atwebpages.com/getSelectionData.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true) {
          setState(() {
            classBudgets = (data['budgets'] as List).map((x) => Budget.fromJson(x)).toList();
            classGenders = (data['genders'] as List).map((x) => Gender.fromJson(x)).toList();
            classInterests = (data['interests'] as List).map((x) => Interest.fromJson(x)).toList();
          });
        } else {
          print('Error: Success flag is false in response');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterInterests(String? genderId) {
    if (genderId == null) {
      setState(() {
        filteredInterests = [];
        selectedInterest = null;
      });
      return;
    }

    setState(() {
      filteredInterests = classInterests.where((interest) => interest.genderId == genderId).toList();
      selectedInterest = null;
    });
  }

  void suggestGift() {
    if (selectedBudget != null && selectedInterest != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GiftSuggestionPage(
            budgetId: selectedBudget!,
            interestId: selectedInterest!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both Budget and Interest')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gift Selection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (classBudgets.isEmpty || classGenders.isEmpty || classInterests.isEmpty)
              Center(child: CircularProgressIndicator())
            else ...[
              DropdownButton<String>(
                hint: Text("Select Budget"),
                value: selectedBudget,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBudget = newValue;
                  });
                },
                items: classBudgets.map((budget) {
                  return DropdownMenuItem<String>(
                    value: budget.id,
                    child: Text(budget.amount),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Column(
                children: classGenders.map((gender) {
                  return RadioListTile<String>(
                    title: Text(gender.genderName),
                    value: gender.id,
                    groupValue: selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGender = value;
                        filterInterests(value);
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              if (filteredInterests.isNotEmpty)
                DropdownButton<String>(
                  hint: Text("Select Interest"),
                  value: selectedInterest,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedInterest = newValue;
                    });
                  },
                  items: filteredInterests.map((interest) {
                    return DropdownMenuItem<String>(
                      value: interest.id,
                      child: Text(interest.interestName),
                    );
                  }).toList(),
                )
              else if (selectedGender != null)
                Text("No interests available for the selected gender."),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: suggestGift,
                child: Text('Suggest Gift'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
