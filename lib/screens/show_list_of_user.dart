import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';

import 'chating_screen.dart';

class ShowListOfUsers extends StatelessWidget {
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => ChattingScreen()));
                                },
                                child: Icon(Icons.chat_bubble,
                                    color: Colors.green))),
                      );
                    });
              }

              return Center(child: CircularProgressIndicator());
            }));
  }
}
