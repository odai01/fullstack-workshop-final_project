import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_screen.dart';
import 'add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {});  // Force rebuild to update UI after logout
  }

  Future<void> _addReaction(String postId, String userId, String reaction) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final postSnapshot = await postRef.get();
    if (postSnapshot.exists) {
      final data = postSnapshot.data() as Map<String, dynamic>;
      final reactions = data['reactions'] ?? {};
      reactions[userId] = reaction;
      await postRef.update({'reactions': reactions});
      setState(() {});  // Force rebuild to update UI after reaction
    }
  }

  Future<String> _getUsername(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data()?['username'] ?? 'Unknown';
    }
    return 'Unknown';
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
                  'Hi, ${user.displayName ?? 'User'}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
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
                      final reactions = data.containsKey('reactions') ? data['reactions'] : {};
                      final userReaction = user != null ? reactions[user.uid] : null;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          children: [
                            ListTile(
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
                            if (user != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: userReaction == 'like' ? Colors.blue : Colors.grey,
                                    ),
                                    onPressed: () {
                                      _addReaction(post.id, user.uid, 'like');
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.thumb_down,
                                      color: userReaction == 'dislike' ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () {
                                      _addReaction(post.id, user.uid, 'dislike');
                                    },
                                  ),
                                ],
                              ),
                            if (reactions.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: reactions.entries.map<Widget>((entry) {
                                    return FutureBuilder<String>(
                                      future: _getUsername(entry.key),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Text('Loading...');
                                        }
                                        final reactionUser = snapshot.data ?? 'Unknown';
                                        final reactionType = entry.value;
                                        return Text('$reactionUser reacted with $reactionType');
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
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
