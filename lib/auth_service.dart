// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? get currentUser => _auth.currentUser;
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   Future<String?> registration({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return 'Success';
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         return 'The password provided is too weak.';
//       } else if (e.code == 'email-already-in-use') {
//         return 'The account already exists for that email.';
//       } else {
//         return e.message;
//       }
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   Future<String?> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return 'Success';
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         return 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         return 'Wrong password provided for that user.';
//       } else {
//         return e.message;
//       }
//     } catch (e) {
//       return e.toString();
//     }
//   }

// Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<String> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    
  }

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
