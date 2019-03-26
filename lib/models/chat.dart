import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';
@JsonSerializable()

class Chat {
  final String uid;
  final int count;
  final List<ChatMessage> messages;
  
  //timestamps
  @JsonKey(fromJson: _dateTimeDoNothingSerializer, toJson: _dateTimeDoNothingSerializer)
  final DateTime createdAt;

  Chat(
      {@required this.uid,
      @required this.count,
      @required this.createdAt,
      @required this.messages});
  
  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  static DateTime _dateTimeDoNothingSerializer(DateTime dt) =>
      dt;
}

@JsonSerializable()
class ChatMessage{
  final String uid;
  //timestamps
  @JsonKey(fromJson: _dateTimeDoNothingSerializer, toJson: _dateTimeDoNothingSerializer)
  final DateTime createdAt;
  final String content;

  ChatMessage({
    @required this.uid,
    @required this.createdAt,
    @required this.content,
   });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  static DateTime _dateTimeDoNothingSerializer(DateTime dt) =>
      dt;
}
