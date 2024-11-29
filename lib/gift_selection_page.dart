import 'package:flutter/material.dart';
import 'gift.dart'; // Import the Gift class
import 'gift_display_page.dart'; // Import gift display page

// Sample gift data, assuming the `Gift` class now has a `budget` field.
final List<Gift> giftData = [
  // Male - Gaming
  Gift(name: 'Gaming Mouse', description: 'A high-performance gaming mouse.', interest: 'Gaming', gender: 'Male', budget: 'Low'),
  Gift(name: 'Gaming Headset', description: 'Noise-canceling gaming headset.', interest: 'Gaming', gender: 'Male', budget: 'Medium'),
  Gift(name: 'Gaming Chair', description: 'Ergonomic chair for long gaming sessions.', interest: 'Gaming', gender: 'Male', budget: 'High'),

  // Male - Sports
  Gift(name: 'Water Bottle', description: 'A portable water bottle for hydration during exercise.', interest: 'Sports', gender: 'Male', budget: 'Low'),
  Gift(name: 'Sports Bag', description: 'A spacious bag to carry all sports gear.', interest: 'Sports', gender: 'Male', budget: 'Medium'),
  Gift(name: 'Smart Sports Watch', description: 'A watch with fitness tracking and GPS features for athletes.', interest: 'Sports', gender: 'Male', budget: 'High'),

  // Female - Fashion
  Gift(name: 'Leather Purse', description: 'A stylish leather purse for everyday use.', interest: 'Fashion', gender: 'Female', budget: 'Low'),
  Gift(name: 'Jewelry Set', description: 'A beautiful jewelry set for any occasion.', interest: 'Fashion', gender: 'Female', budget: 'Medium'),
  Gift(name: 'Designer Handbag', description: 'A luxury designer handbag for fashion-forward individuals.', interest: 'Fashion', gender: 'Female', budget: 'High'),

  // Female - Beauty
  Gift(name: 'Skincare Set', description: 'A complete skincare routine for glowing skin.', interest: 'Beauty', gender: 'Female', budget: 'Low'),
  Gift(name: 'Makeup Kit', description: 'A complete makeup kit with high-quality products.', interest: 'Beauty', gender: 'Female', budget: 'Medium'),
  Gift(name: 'Spa Gift Set', description: 'A luxurious spa set for relaxation and rejuvenation.', interest: 'Beauty', gender: 'Female', budget: 'High'),
];

class GiftSelectionPage extends StatefulWidget {
  @override
  _GiftSelectionPageState createState() => _GiftSelectionPageState();
}

class _GiftSelectionPageState extends State<GiftSelectionPage> {
  String? selectedBudget;
  String? selectedGender;
  String? selectedInterest;

  final List<String> budgets = ['Low', 'Medium', 'High'];
  final List<String> genders = ['Male', 'Female'];
  final Map<String, List<String>> interestsByGender = {
    'Male': ['Gaming', 'Sports'],
    'Female': ['Fashion', 'Beauty'],
  };

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
            // Budget Selection with explanation
            Text('Select Your Budget:', style: TextStyle(fontSize: 25)),
            SizedBox(height: 8),
            Text(
              'Low: \$0 - \$50\nMedium: \$51 - \$150\nHigh: \$151 and above',
              style: TextStyle(fontSize: 19),
            ),
            SizedBox(height: 8),
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

            // Gender Selection
            Text('Select Gender:', style: TextStyle(fontSize: 25)),
            Column(
              children: genders.map((gender) {
                return RadioListTile<String>(
                  title: Text(gender),
                  value: gender,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                      selectedInterest = null; // Reset interest when gender changes
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Interest Selection (based on Gender)
            Text('Select Interest:', style: TextStyle(fontSize: 25)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedInterest,
              hint: Text('Choose interest'),
              items: selectedGender == null
                  ? []
                  : interestsByGender[selectedGender]!.map((interest) {
                return DropdownMenuItem(
                  value: interest,
                  child: Text(interest),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedInterest = value;
                });
              },
            ),
            SizedBox(height: 40),

            // Suggest Gift Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  var gift = _generateGift();
                  if (gift != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftDisplayPage(
                          giftName: gift.name,
                          giftDescription: gift.description,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No gift found for your selection!')),
                    );
                  }
                },
                child: Text('Suggest a Gift'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Gift? _generateGift() {
    for (var gift in giftData) {
      // Check if the selected gender, interest, and budget match the gift's attributes
      if (gift.gender == selectedGender &&
          gift.interest == selectedInterest &&
          gift.budget == selectedBudget) {
        return gift;
      }
    }
    return null;
  }
}
