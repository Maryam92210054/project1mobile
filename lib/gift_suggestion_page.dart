import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GiftSuggestionPage extends StatefulWidget {
  final String budgetId;
  final String interestId;

  GiftSuggestionPage({required this.budgetId, required this.interestId});

  @override
  _GiftSuggestionPageState createState() => _GiftSuggestionPageState();
}

class _GiftSuggestionPageState extends State<GiftSuggestionPage> {
  List<dynamic> gifts = [];
  bool isLoading = true;
  TextEditingController receiverController = TextEditingController();
  String? selectedGiftId; // To store the selected gift ID

  @override
  void initState() {
    super.initState();
    fetchGifts();
  }

  Future<void> fetchGifts() async {
    try {
      final response = await http.post(
        Uri.parse('http://giftgenerator.atwebpages.com/getGifts.php'),
        body: {
          'budget_id': widget.budgetId,
          'interest_id': widget.interestId,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          setState(() {
            gifts = data['gifts'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch gifts')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  Future<void> confirmOrder() async {
    if (selectedGiftId == null || receiverController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a gift and enter a receiver name')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://giftgenerator.atwebpages.com/confirmOrder.php'),
        body: {
          'gift_id': selectedGiftId,
          'receiver_name': receiverController.text,
        },
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order confirmed successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while confirming the order')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Suggested Gifts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Receiver's Name Input Field
            TextField(
              controller: receiverController,
              decoration: InputDecoration(
                labelText: 'Receiver\'s Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Gift Suggestions List or Loading Indicator
            isLoading
                ? Center(child: CircularProgressIndicator())
                : gifts.isEmpty
                ? Center(child: Text('No gifts found for the selected criteria'))
                : Expanded(
              child: ListView.builder(
                itemCount: gifts.length,
                itemBuilder: (context, index) {
                  final gift = gifts[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(gift['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description: ${gift['description']}'),
                          Text('Price: \$${gift['price']}'),
                        ],
                      ),
                      trailing: Radio<String>(
                        value: gift['id'].toString(),
                        groupValue: selectedGiftId,
                        onChanged: (value) {
                          setState(() {
                            selectedGiftId = value;
                          });
                          print('Selected Gift ID: $value'); // Debugging log
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // Confirm Order Button
            ElevatedButton(
              onPressed: confirmOrder,
              child: Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }
}
