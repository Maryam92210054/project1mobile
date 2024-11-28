import 'package:flutter/material.dart';
import 'gift_selection_page.dart'; // Import the GiftSelectionPage

void main() {
  runApp(GiftGeneratorApp());
}

class GiftGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gift Generator',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift Generator'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Gift Selection Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GiftSelectionPage()),
            );
          },
          child: Text('Start Gift Selection'),
        ),
      ),
    );
  }
}
