import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/room_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';

import 'chating_screen.dart';

class ShowListOfUsers extends StatelessWidget {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Start Chat"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("users").get().asStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData) {
                if (snapshot.data.docs.length == 0) {
                  return Text("No Users Found");
                }

                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      UserModel userModel =
                          UserModel.fromMap(snapshot.data.docs[index].data());
                      if (userModel.uid ==
                          FirebaseAuth.instance.currentUser.uid) {
                        return Container();
                      }
                      return Card(
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: 32,
                              backgroundImage:
                                  NetworkImage(userModel.profileImage),
                            ),
                            title: Text(userModel.email),
                            subtitle: Text(userModel.name),
                            trailing: InkWell(
                                onTap: () {
                                  checkAndCreateNewRoom(userModel, context);
                                },
                                child: Icon(Icons.chat_bubble,
                                    color: Colors.green))),
                      );
                    });
              }

              return Center(child: CircularProgressIndicator());
            }));
  }

  String createRoomId(UserModel toChatUserModel) {
    // SmallId_LargeId
    String roomID = "";

    print(
        "createRoomId ${user.uid.hashCode} >> ${toChatUserModel.uid.hashCode} ");
    print("createRoomId ${user.uid} >> ${toChatUserModel.uid} ");
    if (user.uid.hashCode > toChatUserModel.uid.hashCode) {
      roomID = toChatUserModel.uid + "_" + user.uid;
    } else if (user.uid.hashCode < toChatUserModel.uid.hashCode) {
      roomID = user.uid + "_" + toChatUserModel.uid;
    } else {
      roomID = user.uid + "_" + toChatUserModel.uid;
    }

    print("createRoomId @$roomID");

    return roomID;
  }

  checkAndCreateNewRoom(UserModel toChatUserModel, BuildContext context) async {
    String roomId = createRoomId(toChatUserModel);

    CollectionReference roomCollectionReference =
        FirebaseFirestore.instance.collection("rooms");

    DocumentSnapshot documentSnapshot =
        await roomCollectionReference.doc(roomId).get();
    RoomModel roomModel = RoomModel();
    if (documentSnapshot.exists) {
      // already created a room
      roomModel = RoomModel.fromMap(documentSnapshot.data());
    } else {
      // create a new room
      roomModel.roomId = roomId;
      roomModel.peerId = toChatUserModel.uid;
      roomModel.participantsList = [];
      roomModel.participantsList.add(toChatUserModel.uid);
      roomModel.participantsList.add(user.uid);
      await roomCollectionReference.doc(roomId).set(roomModel.toMap());
    }

    if (roomModel != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => ChattingScreen(
                    roomModel: roomModel,
                    userModel: toChatUserModel,
                  )));
    }
  }
}
