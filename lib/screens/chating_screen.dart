import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/room_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/widgets/chat_item.dart';

class ChattingScreen extends StatefulWidget {
  RoomModel roomModel;
  UserModel userModel;
  ChattingScreen({this.roomModel, this.userModel});

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  TextEditingController textEditingController = TextEditingController();

  CollectionReference chatsCollectionReferance;

  @override
  void initState() {
    super.initState();
    chatsCollectionReferance = FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.roomModel.roomId)
        .collection("messages");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userModel.name ?? "Chat"),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 9,
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      chatsCollectionReferance.orderBy("timeStamp").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length == 0) {
                        return Center(child: Text("No chats Found"));
                      }

                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (ctx, index) {
                            MessageModel messageModel = MessageModel.fromMap(
                                snapshot.data.docs[index].data());
                            return ChatItem(messageModel);
                          });
                    }

                    return Center(child: CircularProgressIndicator());
                  })),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                        hintText: "Enter message",
                        border: OutlineInputBorder()),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: InkWell(
                        onTap: () {
                          sendMessage();
                        },
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).accentColor,
                        )))
              ],
            ),
          )
        ],
      ),
    );
  }

  sendMessage() async {
    if (textEditingController.text.length == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter message")));
      return;
    }
    String message = textEditingController.text;

    MessageModel messageModel = MessageModel();
    messageModel.message = message;
    await chatsCollectionReferance.add(messageModel.toMap());

    Map<String, dynamic> roomMap = Map();
    roomMap['lastMessage'] = message;
    roomMap['timeStamp'] = FieldValue.serverTimestamp();

    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(widget.roomModel.roomId)
        .update(roomMap);

    textEditingController.clear();
  }
}
