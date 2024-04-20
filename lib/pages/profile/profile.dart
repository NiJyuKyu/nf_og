import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nf_og/components/button.dart';
import 'package:nf_og/constant.dart';
import 'package:nf_og/model/article.dart';
import 'package:nf_og/pages/profile/components/edit_profile.dart';
import 'package:nf_og/pages/signup/components/default_button.dart';
import 'package:nf_og/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> data = {};

  // Sign out button
  DefaultButton signOutButton() {
    return DefaultButton(
      btnText: 'Sign Out',
      onPressed: FirebaseAuth.instance.signOut,
    );
  }

  // Edit button
  IconButton editInfoButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileUI(
              user: currUser,
              refresh: () {
                setState(() {});
              },
            ),
          ),
        );
      },
      icon: Icon(
        Icons.mode_edit_outline_outlined,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  // Get user info
  Widget getUserInfo(context, snapshot) {
    if (snapshot.hasData) {
      data = snapshot.data!.data() as Map<String, dynamic>;

      userGlbData = data;
      bmArticles = userGlbData['bookmark'];
      bm = [];

      bmArticles.forEach((key, value) {
        ArticleModel article = ArticleModel(
          title: key,
          author: value['author'],
          bookmark: value['bookmark'],
          content: value['content'],
          description: value['description'],
          url: value['url'],
          urlToImage: value['urlToImage'],
        );

        bm.add(article);
      });
      return profileUI();
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  // Profile UI
  Container profileUI() {
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 5.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      offset: const Offset(0, 10),
                    )
                  ],
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://i.pinimg.com/originals/f9/d7/b4/f9d7b48367e4acf82c21c504c1d9b6fb.jpg',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Text(
            'Username:',
            style: TextStyle(
              letterSpacing: 2.0,
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            data['username'],
            style: TextStyle(
              letterSpacing: 1.0,
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Email:',
            style: TextStyle(
              letterSpacing: 2.0,
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            '${currUser?.email}',
            style: TextStyle(
              letterSpacing: 1.0,
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          signOutButton(),
          const SizedBox(height: 20.0),
          GestureDetector(
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.wb_sunny
                    : Icons.nights_stay,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        actions: [
          editInfoButton(context),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot?>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc('${currUser?.uid}')
            .get(),
        builder: getUserInfo,
      ),
    );
  }
}
