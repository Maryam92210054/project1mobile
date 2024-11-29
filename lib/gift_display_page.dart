import 'package:flutter/material.dart';

class GiftDisplayPage extends StatelessWidget {
  final String giftName;
  final String giftDescription;

  GiftDisplayPage({
    required this.giftName,
    required this.giftDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggested Gift'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Suggested Gift: $giftName',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                giftDescription,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
