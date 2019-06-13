import 'package:flutter/material.dart';
import '../../models/chat.dart';

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage chatMessage;
  final String userId;
  ChatMessageListItem(this.chatMessage, this.userId);


  _buildChatRow(BuildContext context, double width) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Container(
        //   margin: const EdgeInsets.only(right: 16.0),
        //   child: CircleAvatar(
        //     backgroundColor: Theme.of(context).accentColor,
        //     child: Text(
        //       chatMessage.displayName[0].toUpperCase(),
        //     ),
        //   ),
        // ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: width,
            color: Colors.cyanAccent,
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(chatMessage.displayName,
                    style: Theme.of(context).textTheme.caption),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    chatMessage.content,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildOwnChatRow(BuildContext context, double width) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: width,
            color: Colors.tealAccent,
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(chatMessage.displayName,
                    style: Theme.of(context).textTheme.caption),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    chatMessage.content,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Container(
        //   margin: const EdgeInsets.only(left: 16.0),
        //   child: CircleAvatar(
        //     backgroundColor: Theme.of(context).primaryColor,
        //     child: Text(
        //       chatMessage.displayName[0].toUpperCase(),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.6;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: chatMessage.uid == userId
          ? _buildOwnChatRow(context, width)
          : _buildChatRow(context, width),
    );
  }
}
