import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/chat.dart';
import '../widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  final String gameId;
  ChatPage(this.gameId);

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  ScrollController _scrollController = new ScrollController();

  Widget _buildPageContent(BuildContext context, AppModel model) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat met iedereen in het spel"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/chat_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: _buildListMessages(context, model),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              padding: EdgeInsets.all(10.0),
              child: _buildInput(context, model),
            ),
          ],
        ),
      ),
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
          List<ChatMessage> returnedChatMessages =
              returnedChat.messages.reversed.toList();
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            reverse: true,
            shrinkWrap: true,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return ChatMessageListItem(
                returnedChatMessages[index],
                model.authenticatedUser.uid,
              );
            },
            itemCount: returnedChatMessages.length,
          );
        }
      },
    );
  }

  Widget _buildInput(BuildContext context, AppModel model) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            controller: _messageController,
            focusNode: _focusNode,
            decoration: InputDecoration(hintText: 'Jouw bericht'),
            onSubmitted: (String content) {
              if(_messageController.text.isNotEmpty){
                _sendChatMessage(content, model);
              }
            },
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                if(_messageController.text.isNotEmpty){
                  _sendChatMessage(_messageController.text, model);
                }
              },
            ))
      ],
    );
  }

  void _sendChatMessage(String content, AppModel model) async {
    await model.sendChatMessage(
        widget.gameId, model.authenticatedUser, content);
    _focusNode.unfocus();
    _messageController.clear();
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
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
