import 'package:flutter/material.dart';
import 'package:mobile_gosoft/views/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
            'assets/images/logo.png'), // replace with the path to your logo
      ),
    );
  }
}
