import 'package:flutter/material.dart';
import 'home_page.dart';

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
