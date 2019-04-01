import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat.dart';
import '../models/user.dart';

mixin ChatModel on Model {
  final Firestore _db = Firestore.instance;

  //add chat to the database
  Future<void> addChat(String gameId, String userId) {
    Chat newChat = Chat(
      id: gameId,
      count: 0,
      uid: userId,
      createdAt: DateTime.now(),
      messages: [],
    );
    return _db.collection('chats').document(gameId).setData(newChat.toJson());
  }

  Stream<DocumentSnapshot> fetchChat(String chatId) {
    return _db.collection('chats').document(chatId).snapshots();
    
  }

  Future<void> sendChatMessage(String chatId, User user, String content) {
    final ChatMessage chatMessage = ChatMessage(
      uid: user.uid,
      displayName: user.displayName,
      content: content,
      createdAt: DateTime.now(),
    );

    final DocumentReference chatRef = _db.collection('chats').document(chatId);
    return chatRef.updateData({
      'messages': FieldValue.arrayUnion([chatMessage.toJson()])
    });
  }

  Future<void> deleteChatMessage(
      Chat chat, ChatMessage chatMessage, String userId) {
    if (chat.uid == userId || chatMessage.uid == userId) {
      //allowed to delete
      final DocumentReference chatRef =
          _db.collection('chats').document(chat.uid);
      return chatRef.updateData({
        'messages': FieldValue.arrayRemove([chatMessage.toJson()])
      });
    } else {
      return null;
    }
  }


}
