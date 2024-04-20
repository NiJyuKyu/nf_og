import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  final String title;
  const Comment({
    super.key,
    required this.title,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  List<dynamic> comments = [];
  Map<String, dynamic> reports = {};

  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Ensure the 'social' collection exists
    _ensureSocialCollectionExists();
  }

  Future<void> _ensureSocialCollectionExists() async {
    final socialDoc = FirebaseFirestore.instance.collection('social').doc('comments');
    final docSnapshot = await socialDoc.get();
    if (!docSnapshot.exists) {
      // If the document doesn't exist, create it
      await socialDoc.set({});
    }
  }

  // Function to get the username of the currently logged-in user
  Future<String?> _getCurrentUsername() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      return userDoc['username'];
    }
    return null; // Return null if user is not logged in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('social')
            .doc('comments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            comments = snapshot.data!.data()![widget.title] ?? [];

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comments[index]['username']),
                        subtitle: Text(comments[index]['comment']),
                        trailing: IconButton(
                          icon: const Icon(Icons.report),
                          onPressed: () {
                            // Report comment logic
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Type your comment here',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          if (_commentController.text.isNotEmpty) {
                            final username = await _getCurrentUsername();
                            if (username != null) {
                              setState(() {
                                comments.add({
                                  'username': username,
                                  'comment': _commentController.text,
                                });

                                // Update comments in Firestore
                                FirebaseFirestore.instance
                                    .collection('social')
                                    .doc('comments')
                                    .update({
                                  widget.title: comments,
                                });

                                // Show notification
                                Flushbar(
                                  message: 'Comment added successfully',
                                  duration: const Duration(seconds: 2),
                                ).show(context);

                                // Clear text field
                                _commentController.clear();
                              });
                            } else {
                              // Handle if user is not logged in
                              // You can show an error message or redirect to login page
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
