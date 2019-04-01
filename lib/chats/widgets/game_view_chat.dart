import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/chat.dart';

class GameViewChat extends StatefulWidget {
  final String gameId;
  GameViewChat(this.gameId);

  @override
  State<StatefulWidget> createState() {
    return _GameViewChatState();
  }
}

class _GameViewChatState extends State<GameViewChat> {
  final TextEditingController _messageController = TextEditingController();

  Widget _buildPageContent(BuildContext context, AppModel model) {
    return Column(
      children: <Widget>[
        Flexible(
          child: _buildListMessages(context, model),
        ),
        Divider(height: 1.0),
        Container(
          padding: EdgeInsets.all(10.0),
          child: _buildInput(context, model),
        ),
      ],
    );
  }

  Widget _buildListMessages(BuildContext context, AppModel model) {
    return StreamBuilder(
      stream: model.fetchChat(widget.gameId),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          Map<String, dynamic> chatData = snapshot.data.data;
          chatData['id'] = snapshot.data.documentID;
          Chat returnedChat = Chat.fromJson(chatData);
          List<ChatMessage> returnedChatMessages = returnedChat.messages;
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            // reverse: true,
            itemBuilder: (BuildContext context, int index) {
              return _buildItem(returnedChatMessages[index]);
            },
            itemCount: returnedChatMessages.length,
          );
        }
      },
    );
  }

  Widget _buildItem(ChatMessage chatMessage) {
    return ListTile(
      title: Text(chatMessage.displayName),
      subtitle: Text(chatMessage.content),
    );
  }

  Widget _buildInput(BuildContext context, AppModel model) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(hintText: 'Jouw bericht'),
            onSubmitted: (String content) {
              print(content);
            },
            // autofocus: true,
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {},
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return _buildPageContent(context, model);
      },
    );
  }
}
