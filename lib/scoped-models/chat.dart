import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat.dart';

mixin ChatModel on Model {
  final Firestore _db = Firestore.instance;

  //add chat to the database
  Future<void> addChat(String gameId, String userId) {
    Chat newChat = Chat(
      count: 0,
      uid: userId,
      createdAt: DateTime.now(),
      messages: [],
    );
    return _db.collection('chats').document(gameId).setData(newChat.toJson());
  }
}
