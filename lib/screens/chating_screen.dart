import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chat_item.dart';

class ChattingScreen extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chating Screen"),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 9,
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ChatItem(index);
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

  sendMessage() {
    if (textEditingController.text == null) {
      return;
    }
    String message = textEditingController.text;
  }
}
