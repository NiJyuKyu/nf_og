import 'package:flutter/material.dart';
import 'package:nf_og/constant.dart';
import 'package:nf_og/model/article.dart';
import 'package:nf_og/pages/home/components/blog_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Bookmark extends StatefulWidget {
  final List<ArticleModel> bm;
  const Bookmark({super.key, Key? keys, required this.bm});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void toggleBookmarkStatus(int index) {
    setState(() {
      if (index >= 0 && index < widget.bm.length && widget.bm[index].bookmark != null) {
        widget.bm[index].bookmark = !(widget.bm[index].bookmark!);
        _updateBookmarkStatus(index);
      }
    });
  }

  Future<void> _updateBookmarkStatus(int index) async {
    final User? user = _auth.currentUser;
    if (user != null && widget.bm[index].title != null && widget.bm[index].bookmark != null) {
      final String userId = user.uid;
      final DocumentReference userDocRef = _firestore.collection('users').doc(userId);

      try {
        final DocumentSnapshot<Object?> userDocSnapshot = await userDocRef.get();
        final DocumentSnapshot<Map<String, dynamic>> userDoc = userDocSnapshot as DocumentSnapshot<Map<String, dynamic>>;

        final Map<String, dynamic>? userData = userDoc.data();

        if (userData != null) {
          List<Map<String, dynamic>> bookmark = List<Map<String, dynamic>>.from(userData['bookmark'] ?? []);

          if (widget.bm[index].bookmark!) {
            // Add the bookmarked article to the bookmarks list
            bookmark.add({
              'title': widget.bm[index].title,
              'author': widget.bm[index].author,
              'description': widget.bm[index].description,
              'url': widget.bm[index].url,
              'urlToImage': widget.bm[index].urlToImage,
              'content': widget.bm[index].content,
            });
          } else {
            // Remove the bookmarked article from the bookmarks list
            bookmark.removeWhere((bookmark) => bookmark['title'] == widget.bm[index].title);
          }

          // Update the bookmarks field in the user's document
          await userDocRef.update({'bookmark': bookmark});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.bm[index].bookmark! ? 'Article bookmarked' : 'Bookmark removed')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update bookmark: $error')),
        );
      }
    }
  }

  Widget genBMArticles() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            itemCount: widget.bm.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return BlogTile(
                imageUrl: widget.bm[index].urlToImage ?? '',
                title: widget.bm[index].title ?? '',
                desc: widget.bm[index].description ?? '',
                url: widget.bm[index].url ?? '',
                bm: widget.bm,
                articles: glbArticles,
                function: () {
                  toggleBookmarkStatus(index);
                },
                index: index,
                isBookmark: widget.bm[index].bookmark ?? false,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkColor,
      body: (!(userGlbData['enable'] ?? false))
          ? const Center(
              child: Text(
                'Account disabled',
                style: kTitleTextStyle,
              ),
            )
          : (widget.bm.isEmpty)
              ? const Center(
                  child: Text('No Articles Saved', style: kSubTextStyle),
                )
              : genBMArticles(),
    );
  }
}
