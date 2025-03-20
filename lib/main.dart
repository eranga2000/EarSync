import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_player/auth_service.dart';
import 'package:music_player/create_account_page.dart';
import 'package:music_player/home_page.dart';
import 'package:music_player/login_page.dart';
import 'package:music_player/spash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main()async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( 
  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: MainApp(),
  ));
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
           '/home': (context) => HomePage(),
         }, 
     
    );
  }
}
