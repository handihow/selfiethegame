import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  final String id;
  final String uid;
  final int count;
  final List<ChatMessage> messages;

  //timestamps
  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime createdAt;

  Chat(
      {@required this.id,
      @required this.uid,
      @required this.count,
      @required this.createdAt,
      @required this.messages});

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  static DateTime _dateTimeDoNothingSerializer(DateTime dt) => dt;

  static DateTime _timestampToDateSerializer(dt) {
    try {
      //this works on iOS
      return dt.toDate();
    } catch (e) {
      //this works on Android
      return dt;
    }
  }
}

@JsonSerializable()
class ChatMessage {
  final String uid;
  final String displayName;
  //timestamps
  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime createdAt;
  final String content;

  ChatMessage({
    @required this.uid,
    @required this.displayName,
    @required this.createdAt,
    @required this.content,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  static DateTime _dateTimeDoNothingSerializer(DateTime dt) => dt;

  static DateTime _timestampToDateSerializer(dt) {
    try {
      //this works on iOS
      return dt.toDate();
    } catch (e) {
      //this works on Android
      return dt;
    }
  }
}
