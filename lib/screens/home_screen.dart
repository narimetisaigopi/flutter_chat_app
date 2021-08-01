import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/room_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/screens/splash_screen.dart';

import '../utilities.dart';
import 'chating_screen.dart';
import 'edit_profile.dart';
import 'show_list_of_user.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = FirebaseAuth.instance.currentUser;

  UserModel logginUserModel;

  getUserData() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      this.logginUserModel = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(logginUserModel != null
            ? "Logged as ${logginUserModel.name}"
            : "Home"),
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("rooms")
              .where("participantsList", arrayContains: user.uid)
              .orderBy("timeStamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.hasData) {
              if (snapshot.data.docs.length == 0) {
                return Center(child: Text("No rooms"));
              }
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  RoomModel roomModel =
                      RoomModel.fromMap(snapshot.data.docs[index].data());
                  return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(roomModel.senderId == user.uid
                              ? roomModel.peerId
                              : roomModel.senderId)
                          .get()
                          .asStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserModel userModel =
                              UserModel.fromMap(snapshot.data);
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => ChattingScreen(
                                              roomModel: roomModel,
                                              userModel: userModel,
                                            )));
                              },
                              leading: CircleAvatar(
                                radius: 32,
                                backgroundImage:
                                    NetworkImage(userModel.profileImage),
                              ),
                              title: Text(userModel.name),
                              subtitle: Text(roomModel.lastMessage ?? ""),
                              trailing: Text(roomModel.timeStamp != null
                                  ? Utilities.displayTimeAgoFromTimestamp(
                                      roomModel.timeStamp.toDate().toString())
                                  : ""),
                            ),
                          );
                        }
                        return Container();
                      });
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
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
