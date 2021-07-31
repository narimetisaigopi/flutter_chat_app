import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  int index;
  ChatItem(this.index);
  bool left = false;
  @override
  Widget build(BuildContext context) {
    if (index % 2 == 0) {
      left = true;
    } else {
      left = false;
    }
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
        decoration: BoxDecoration(color: Colors.grey),
        child: Column(
          crossAxisAlignment:
              left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              "your message will be here",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              "09:24 AM",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
