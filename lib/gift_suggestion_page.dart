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
  String? selectedGiftId;
  int _selectedIndex = 1;

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
          _showSnackBar(data['message']);
        }
      } else {
        _showSnackBar('Failed to fetch gifts');
      }
    } catch (e) {
      print('Error: $e');
      _showSnackBar('An error occurred');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> confirmOrder() async {
    if (selectedGiftId == null || receiverController.text.isEmpty) {
      _showSnackBar('Please select a gift and enter a receiver name');
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
        _showSnackBar('Order confirmed successfully!');
      } else {
        _showSnackBar(data['message']);
      }
    } catch (e) {
      print('Error: $e');
      _showSnackBar('An error occurred while confirming the order');
    }
  }

  void _onNavBarTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/giftSelection');
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                            Icon(Icons.star, size: 80, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              "Suggested Gifts",
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: receiverController,
                    decoration: InputDecoration(
                      labelText: 'Receiver\'s Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : gifts.isEmpty
                      ? const Center(child: Text('No gifts found for the selected criteria'))
                      : Expanded(
                    child: ListView.builder(
                      itemCount: gifts.length,
                      itemBuilder: (context, index) {
                        final gift = gifts[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: gift['image_url'] != null &&
                                gift['image_url'].isNotEmpty
                                ? Image.network(
                              gift['image_url'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image, size: 50);
                              },
                            )
                                : Icon(Icons.image_not_supported, size: 50),
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
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: confirmOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Confirm Order',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Gifts',
          ),
        ],
      ),
    );
  }
}

class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);
    final firstControlPoint = Offset(size.width / 2, size.height);
    final firstEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
