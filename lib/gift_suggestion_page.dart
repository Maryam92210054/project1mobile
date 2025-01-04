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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Suggested Gifts')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : gifts.isEmpty
          ? Center(child: Text('No gifts found for the selected criteria'))
          : ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(gift['name']), // Displaying gift name
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: ${gift['description']}'), // Displaying description
                  Text('Price: \$${gift['price']}'), // Displaying price
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
