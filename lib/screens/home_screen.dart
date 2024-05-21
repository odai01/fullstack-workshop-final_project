import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workshop_project_template/utils/mock_data.dart';
import 'package:workshop_project_template/utils/utils.dart';

import '../firebase/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: isUserSignedIn()
            ? Text('Welcome, ${FirebaseAuth.instance.currentUser?.displayName}')
            : Text("Home Screen"),
        actions: [
          IconButton(
            onPressed:
                isUserSignedIn() ? () => goToAddPostScreen(context) : null,
            icon: Icon(
              Icons.add,
            ),
          ),
          IconButton(
            onPressed: () =>
                {isUserSignedIn() ? logout() : goToAuthScreen(context)},
            icon: Icon(
              isUserSignedIn() ? Icons.logout : Icons.login,
            ),
          ),
        ],
      ),
      body: Center(
        child: getFullFeedWidget(texts),
      ),
    );
  }

  Widget getFullFeedWidget(List feeds) {
    // TODO - replace Placeholder with implementation of the home screen.
    // Here you should get the posts from the Firebase database using the variable `db`.
    // When getting the data, you will need to sort it according to the post's timestamp.

    // If you want, you can use the `getSinglePostWidget()` to add the design a single post.
    return Placeholder();
  }

  Widget getSinglePostWidget(String username, String text) {
    // TODO - (Optional) You can use this function to implement the design of a single post.
    return Placeholder();
  }

  void logout() {
    print("Logging out");
    FirebaseAuth.instance.signOut();
    setState(() {});
  }
}
