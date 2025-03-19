import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_player/create_account_page.dart';
import 'package:music_player/login_page.dart';
import 'package:music_player/spash_screen.dart';

Future<void> main()async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
