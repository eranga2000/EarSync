import 'package:flutter/material.dart';
import 'package:music_player/auth_service.dart';
import 'package:music_player/screen_size.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo.png', scale: 2.0),

              Text(
                'EarSync',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.0),
              Text(
                "Play YT Music",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w100),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _emailController,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),

                    hintText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Password',
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(8.0),
                  minimumSize: const Size(350.0, 35.0),
                  backgroundColor: const Color.fromRGBO(68, 188, 60, 1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  try{
                      Provider.of<AuthService>(context, listen: false).login(
                  _emailController.text,
                  _passwordController.text,
                  );
                  Navigator.pushReplacementNamed(context, '/home');
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text("No internet connection!"),
    backgroundColor: Colors.orange,
    action: SnackBarAction(
      label: "Retry",
      textColor: Colors.white,
      onPressed: () {
        // Your retry function here
      },
    ),
  ),
);

                  }
                
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(ScreenSize.screenWidth(context) / 1.1, 35.0),
                  backgroundColor: const Color.fromARGB(255, 241, 252, 241),
                  foregroundColor: const Color.fromARGB(255, 9, 0, 0),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
