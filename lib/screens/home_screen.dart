import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/splash_screen.dart';

import 'edit_profile.dart';
import 'show_list_of_user.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (ctx) => SplashScreen()),
                    (route) => false);
              },
              icon: Icon(Icons.logout)),
          IconButton(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => EditProfile()));
              },
              icon: Icon(Icons.edit)),
        ],
      ),
      body: Center(child: Text("Welcome to my app")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => ShowListOfUsers()));
        },
        child: Icon(Icons.chat_bubble_outline_sharp),
      ),
    );
  }
}
