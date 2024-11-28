import 'package:flutter/material.dart';
import 'gift_display_page.dart'; // Import the GiftDisplayPage

class GiftSelectionPage extends StatefulWidget {
  @override
  _GiftSelectionPageState createState() => _GiftSelectionPageState();
}

class _GiftSelectionPageState extends State<GiftSelectionPage> {
  String? selectedBudget;
  String? selectedGender;
  String? selectedRelationship;

  final List<String> budgets = ['Low', 'Medium', 'High'];
  final List<String> genders = ['Male', 'Female'];
  final List<String> relationships = ['Friends', 'Family', 'Lovers'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift Selection'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Your Budget:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedBudget,
              hint: Text('Choose budget'),
              items: budgets.map((budget) {
                return DropdownMenuItem(
                  value: budget,
                  child: Text(budget),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBudget = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Select Gender of Gift Receiver:', style: TextStyle(fontSize: 18)),
            Column(
              children: genders.map((gender) {
                return RadioListTile<String>(
                  title: Text(gender),
                  value: gender,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Select Your Relationship:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedRelationship,
              hint: Text('Choose relationship'),
              items: relationships.map((relationship) {
                return DropdownMenuItem(
                  value: relationship,
                  child: Text(relationship),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRelationship = value;
                });
              },
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  var giftData = _generateGift();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GiftDisplayPage(
                        giftName: giftData['name']!,
                        giftPrice: giftData['price']!,
                        giftDescription: giftData['description']!,
                      ),
                    ),
                  );
                },
                child: Text('Suggest a Gift'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _generateGift() {
    if (selectedBudget == null || selectedGender == null || selectedRelationship == null) {
      return {
        'name': 'Please select all options!',
        'price': '',
        'description': ''
      };
    }

    final gifts = [
      {'budget': 'Low', 'gender': 'Male', 'relationship': 'Friends', 'name': 'Keychain', 'price': '\$5', 'description': 'A simple keychain to carry around.'},
      {'budget': 'Low', 'gender': 'Male', 'relationship': 'Family', 'name': 'Coffee Mug', 'price': '\$10', 'description': 'A personalized coffee mug for your family.'},
      // Add more gift options here...
    ];

    for (var gift in gifts) {
      if (gift['budget'] == selectedBudget &&
          gift['gender'] == selectedGender &&
          gift['relationship'] == selectedRelationship) {
        return {
          'name': gift['name'] as String,
          'price': gift['price'] as String,
          'description': gift['description'] as String,
        };
      }
    }

    return {
      'name': 'No gift found for your selection!',
      'price': '',
      'description': ''
    };
  }
}
