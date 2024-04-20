import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:nf_og/constant.dart';
import 'package:nf_og/model/article.dart';
import 'package:nf_og/pages/comment/comment.dart';
import 'package:nf_og/pages/home/components/arcticle_view.dart';

class BlogTile extends StatefulWidget {
  final String imageUrl, title, desc, url;
  final List<ArticleModel> bm;
  final List<ArticleModel> articles;
  final VoidCallback function;
  final int index;
  final bool isBookmark;

  const BlogTile({super.key, 
    required this.imageUrl,
    required this.title,
    required this.desc,
    required this.url,
    required this.function,
    required this.bm,
    required this.articles,
    required this.index,
    required this.isBookmark,
  });

  @override
  State<BlogTile> createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  void _toggleBookmarkStatus() {
    setState(() {
      if (!widget.isBookmark) {
        // Add article to bookmarks
        ArticleModel articleModel = ArticleModel(
          title: widget.title,
          author: '',
          description: widget.desc,
          url: widget.url,
          urlToImage: widget.imageUrl,
          content: null,
          bookmark: true,
        );

        widget.bm.add(articleModel);

        // Show bookmark added message
        _showFlushbarMessage('Added to Bookmarks');
      } else {
        // Remove article from bookmarks
        widget.bm.removeWhere((article) => article.title == widget.title);

        // Show bookmark removed message
        _showFlushbarMessage('Removed from Bookmarks');
      }

      // Update bookmark status
      widget.function();
    });
  }

  void _showFlushbarMessage(String message) {
    Flushbar(
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      flushbarPosition: FlushbarPosition.TOP,
      isDismissible: true,
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration: const Duration(seconds: 2),
      leftBarIndicatorColor: kLightColor,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ArticleView(
            blogUrl: widget.url,
          );
        }));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: kDefaultPadding),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(kDefaultRadius),
              child: Stack(
                children: [
                  Image.network(widget.imageUrl),
                  _buildBookmarkButton(),
                  _buildCommentButton(),
                ],
              ),
            ),
            Text(
              widget.title,
              style: kLightTextStyle,
            ),
            Text(
              widget.desc,
              style: kSmallTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkButton() {
    return Positioned(
      top: 10,
      right: 5,
      child: IconButton(
        onPressed: _toggleBookmarkStatus,
        icon: Icon(
          widget.isBookmark ? Icons.bookmark_added : Icons.bookmark_add,
          color: Colors.amber,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildCommentButton() {
    return Positioned(
      bottom: 10,
      left: 5,
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Comment(title: widget.title),
            ),
          );
        },
        icon: const Icon(
          Icons.comment,
          color: Colors.amber,
          size: 40,
        ),
      ),
    );
  }
}
