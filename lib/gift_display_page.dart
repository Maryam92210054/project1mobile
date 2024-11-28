import 'package:flutter/material.dart';

class GiftDisplayPage extends StatelessWidget {
  final String giftName;
  final String giftPrice;
  final String giftDescription;

  GiftDisplayPage({required this.giftName, required this.giftPrice, required this.giftDescription});

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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Price: $giftPrice',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                giftDescription,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
