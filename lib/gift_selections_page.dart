import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
        const SnackBar(content: Text('Please select both Budget and Interest')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom header with a curved shape and gradient
            ClipPath(
              clipper: CustomHeaderClipper(),
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'), // Background image
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.card_giftcard, size: 80, color: Colors.white),
                              SizedBox(height: 10),
                              Text(
                                "Gift Selection",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Remaining content of the page
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: classBudgets.isEmpty || classGenders.isEmpty || classInterests.isEmpty
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose your preferences:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Budget selection in a Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Budget',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedBudget,
                        items: classBudgets.map((budget) {
                          return DropdownMenuItem<String>(
                            value: budget.id,
                            child: Text(budget.amount),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedBudget = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Gender selection with radio buttons in a Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            "Select Gender:",
                            style: TextStyle(fontSize: 18),
                          ),
                          Column(
                            children: classGenders.map((gender) {
                              return RadioListTile<String>(
                                title: Text(gender.genderName),
                                value: gender.id,
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                    filterInterests(value);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Interest selection in a Card
                  if (filteredInterests.isNotEmpty)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Interest',
                            border: OutlineInputBorder(),
                          ),
                          value: selectedInterest,
                          items: filteredInterests.map((interest) {
                            return DropdownMenuItem<String>(
                              value: interest.id,
                              child: Text(interest.interestName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedInterest = value;
                            });
                          },
                        ),
                      ),
                    )
                  else if (selectedGender != null)
                    const Text(
                      "No interests available for the selected gender.",
                      style: TextStyle(color: Colors.black),
                    ),
                  SizedBox(height: 20),
                  // Suggest Gift button inside a card with a modern style
                  Center(
                    child: ElevatedButton(
                      onPressed: suggestGift,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: Text("Suggest Gift"),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper to create a curved header
class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);
    final firstControlPoint = Offset(size.width / 2, size.height);
    final firstEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

void main() {
  runApp(MaterialApp(
    home: GiftSelectionPage(),
  ));
}
