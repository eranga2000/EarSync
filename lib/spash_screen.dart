import 'package:flutter/material.dart';
import 'package:music_player/login_page.dart';

// Your main app screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) { // Check if widget is still active before navigating
      Navigator.pushReplacementNamed(context,'/login');}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Same as native splash
      body: Center(
        child: Image.asset("assets/images/logo.png"),  // Custom splash image
      ),
    );
  }
}
