import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseURL = 'giftgenerator.atwebpages.com';

class AuthPage extends StatefulWidget {
  final bool isSignIn;

  const AuthPage({required this.isSignIn, super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void handleSubmit() async {
    setState(() {
      _isLoading = true;
    });

    final endpoint = widget.isSignIn ? 'signIn.php' : 'logIn.php';
    final url = Uri.http(baseURL, '/$endpoint');

    final body = {
      'username': _usernameController.text,
      if (widget.isSignIn) 'email': _emailController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );
          if (!widget.isSignIn) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSignIn ? 'Sign Up' : 'Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            if (widget.isSignIn)
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : handleSubmit,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(widget.isSignIn ? 'Sign Up' : 'Log In'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthPage(isSignIn: !widget.isSignIn),
                  ),
                );
              },
              child: Text(widget.isSignIn
                  ? 'Already have an account? Log In'
                  : 'Don’t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
