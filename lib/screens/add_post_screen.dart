import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  // You can use `db` to access the Firebase database.
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // TODO - You can change the title.
        title: Text("Add Post"),
      ),
      body: Center(
        child: getPageWidgets(),
      ),
    );
  }

  Widget getPageWidgets() {
    // TODO - Replace the placeholder with implementation
    return Placeholder();
  }

  void uploadPostToDatabase() {
    // TODO - Here you can use the `db` variable to upload the new post to the Firebase database.
    // When uploading the post to the database, make sure to include the timestamp of the post.
    // The timestamp will be used to sort the posts in the home screen.
    // You can get the current timestamp using:
    // `DateTime.now().millisecondsSinceEpoch`
  }
}
