import 'package:flutter/material.dart';
import 'package:music_player/create_account_page.dart';
import 'package:music_player/login_page.dart';
import 'package:music_player/spash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'EarSync',
      debugShowCheckedModeBanner: false,
         initialRoute: '/',
         routes: {
           '/': (context) => SplashScreen(),
           '/signup': (context) => CreateAccountPage(),
           '/login': (context) => LoginPage(),
         }, 
     
    );
  }
}
