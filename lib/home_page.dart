import 'package:flutter/material.dart';
import 'gift_selections_page.dart'; // Import the correct page

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Home Page!'),
            const SizedBox(height: 20), // Adds spacing between text and button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectionScreen(userId: 1), // Replace '1' with the actual userId
                  ),
                );
              },
              child: const Text('Go to Gift Selection'),
            ),

          ],
        ),
      ),
    );
  }
}
