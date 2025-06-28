import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  void _continue(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenIntro', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _continue(context),
          child: const Text('Get Started'),
        ),
      ),
    );
  }
}
