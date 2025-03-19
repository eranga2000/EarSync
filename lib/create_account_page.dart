import 'package:flutter/material.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

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
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Password',
                  ),
                ),
              ),
              SizedBox(height: 12.0),
               Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_reset),
                    hintText: 'Confirm Password',
                  ),
                ),
              ),
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
                onPressed: () {},
                child: const Text(
                  'Create',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(350.0, 35.0),
                  backgroundColor: const Color.fromARGB(255, 241, 252, 241),
                  foregroundColor: const Color.fromARGB(255, 9, 0, 0),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                 
                },
                child: const Text(
                  'Login',
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
