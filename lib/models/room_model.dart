// RoomModel sai (190) and gopi (12)
// MessageModel

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomModel {
  String roomId;
  String senderId; // this ui
  String peerId; // manam yavariki aethy message pampisthuno valu
  Timestamp timeStamp;
  String lastMessage;
  List participantsList = [];

  Timestamp lastMessageTimeStamp;

  RoomModel(
      {this.roomId,
      this.senderId,
      this.peerId,
      this.timeStamp,
      this.lastMessage,
      this.participantsList,
      this.lastMessageTimeStamp});

  factory RoomModel.fromMap(Map map) {
    return RoomModel(
      lastMessageTimeStamp: map['lastMessageTimeStamp'],
      roomId: map['roomId'],
      senderId: map['senderId'],
      peerId: map['peerId'],
      timeStamp: map['timeStamp'],
      lastMessage: map['lastMessage'],
      participantsList: map['participantsList'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'participantsList': participantsList,
      'lastMessage': "",
      'peerId': peerId,
      'timeStamp': FieldValue.serverTimestamp(),
      'senderId': FirebaseAuth.instance.currentUser.uid
    };
  }
}
