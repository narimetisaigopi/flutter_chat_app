import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message_model.dart';

import '../utilities.dart';

class ChatItem extends StatelessWidget {
  MessageModel messageModel;
  ChatItem(this.messageModel);
  bool left = false;
  @override
  Widget build(BuildContext context) {
    if (messageModel.senderId == FirebaseAuth.instance.currentUser.uid) {
      left = false;
    } else {
      left = true;
    }
    return Row(
      mainAxisAlignment: left ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Card(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.5,
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: left ? Colors.red[300] : Colors.green[300]),
            child: Column(
              crossAxisAlignment:
                  left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  messageModel.message ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  height: 6,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    messageModel.timeStamp != null
                        ? Utilities.displayTimeAgoFromTimestamp(
                            messageModel.timeStamp.toDate().toString())
                        : "",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
