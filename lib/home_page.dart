import 'package:flutter/material.dart';
import 'package:music_player/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
       
                if (!context.mounted) return;
                Navigator.of(context).pushReplacementNamed('/login');
     Provider.of<AuthService>(context, listen: false).logout();
              },
              child: Text('Sign Out'),
            ),
            Text(
              Provider.of<AuthService>(context).user.toString(),
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
