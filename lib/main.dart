import 'package:flutter/material.dart';
import 'auth_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthPage(isSignIn: false), // Default is the Log In page
      routes: {
        '/home': (context) => const HomePage(),


      },
    );
  }
}
