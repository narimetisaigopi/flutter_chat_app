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

  UserModel userModel;

  getUserData() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data());
    });
  }

  @override
  initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel != null ? "Logged as ${userModel.name}" : "Home"),
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
              .orderBy("lastMessageTimeStamp", descending: true)
              .get()
              .asStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              if (snapshot.data.docs.length == 0) {
                return Center(child: Text("No Rooms Found"));
              }

              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    RoomModel roomModel =
                        RoomModel.fromMap(snapshot.data.docs[index].data());

                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(user.uid == roomModel.senderId
                                ? roomModel.peerId
                                : roomModel.senderId)
                            .get()
                            .asStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container(
                              child: Text(""),
                            );
                          }
                          if (snapshot.hasData) {
                            UserModel userModel =
                                UserModel.fromMap(snapshot.data);
                            print("userModel " + userModel.toMap().toString());
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => ChattingScreen(
                                              roomModel: roomModel,
                                            )));
                              },
                              child: Card(
                                  child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 32,
                                        backgroundImage: NetworkImage(
                                            userModel.profileImage),
                                      ),
                                      title: Text(userModel.name),
                                      subtitle: Text(roomModel.lastMessage),
                                      trailing: Text(
                                        roomModel.lastMessageTimeStamp != null
                                            ? Utilities
                                                .displayTimeAgoFromTimestamp(
                                                    roomModel
                                                        .lastMessageTimeStamp
                                                        .toDate()
                                                        .toString())
                                            : "",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ))),
                            );
                          }
                          return Container();
                        });
                  });
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
