import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_screen.dart';  // Import AuthScreen
import 'add_post_screen.dart';  // Import AddPostScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {});  // Force rebuild to update UI after logout
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: <Widget>[
          if (user != null)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          if (user == null)
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: <Widget>[
            if (user != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Hi, ${user.displayName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> postSnapshot) {
                  if (postSnapshot.hasError) {
                    return Center(child: Text('An error occurred!'));
                  }
                  if (!postSnapshot.hasData || postSnapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No posts found.'));
                  }
                  final postDocs = postSnapshot.data!.docs;
                  return ListView.builder(
                    itemCount: postDocs.length,
                    itemBuilder: (ctx, index) {
                      final post = postDocs[index];
                      final data = post.data() as Map<String, dynamic>;
                      final username = data.containsKey('username') ? data['username'] : 'Unknown';
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(data['title']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['content']),
                              SizedBox(height: 8),
                              Text(
                                'Posted by: $username',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: user != null
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddPostScreen()),
                );
              },
            )
          : null,
    );
  }
}
