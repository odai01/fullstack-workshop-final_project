import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // You can use `firebaseAuth` to access Firebase authentication.
  var firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // TODO - You can change the title of the screen.
          title: Text("Login Screen"),
        ),
        body: Center(
          child: getAuthForm(context),
        ));
  }

  Widget getAuthForm(BuildContext context) {
    // TODO - Replace the Placeholder with the implementation.
    return Placeholder();
  }

  void createUser(BuildContext context) async {
    // TODO - Use the `firebaseAuth` variable to create a new user in Firebase.
    // After creating a user, use `firebaseAuth` to update the user's display name.

    // Then you can go back to the home screen using `goBackToHomeScreen(context);`
    goBackToHomeScreen(context);
  }

  void loginUser(BuildContext context) async {
    // TODO - Use the `firebaseAuth` variable to sign the user in using email + password.

    // After successfully loggin in, you can go back to the home screen using `goBackToHomeScreen(context);`
    goBackToHomeScreen(context);
  }
}
