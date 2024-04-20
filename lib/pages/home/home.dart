import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nf_og/constant.dart';
import 'package:nf_og/model/article.dart';
import 'package:nf_og/model/catergory.dart';
import 'package:nf_og/pages/home/components/blog_tile.dart';
import 'package:nf_og/pages/home/components/category_title.dart';
import 'package:nf_og/services/data.dart';
import 'package:nf_og/services/news.dart';
import 'package:nf_og/theme/theme.dart';

class Home extends StatefulWidget {
  final List<ArticleModel> articles;

  const Home({super.key, required this.articles});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser;
  List<CategoryModel> categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  void getNews() async {
    News news = News();
    await news.getNews();
    setState(() {
      widget.articles.clear();
      widget.articles.addAll(news.news);
      glbArticles = news.news;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Use lightMode theme if brightness is light, otherwise use darkMode theme
      data: Theme.of(context).brightness == Brightness.light ? lightMode : darkMode,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: _loading || userGlbData['enable'] == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : !userGlbData['enable']
                ? const Center(
                    child: Text(
                      'Account disabled',
                      style: kTitleTextStyle,
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            itemCount: categories.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CategoryTile(
                                imageUrl: categories[index].imageUrl,
                                categoryName: categories[index].categoryName,
                              );
                            },
                          ),
                        ),
                        ListView.builder(
                          itemCount: widget.articles.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return BlogTile(
                              imageUrl: widget.articles[index].urlToImage!,
                              title: widget.articles[index].title!,
                              desc: widget.articles[index].description!,
                              url: widget.articles[index].url!,
                              bm: bm,
                              function: () {},
                              articles: widget.articles,
                              index: index,
                              isBookmark: widget.articles[index].bookmark ?? false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
