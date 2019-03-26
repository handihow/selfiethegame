// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map json) {
  return Chat(
      uid: json['uid'] as String,
      count: json['count'] as int,
      createdAt: json['createdAt'] == null
          ? null
          : Chat._dateTimeDoNothingSerializer(json['createdAt'] as DateTime),
      messages: (json['messages'] as List)
          ?.map((e) => e == null
              ? null
              : ChatMessage.fromJson((e as Map)?.map(
                  (k, e) => MapEntry(k as String, e),
                )))
          ?.toList());
}

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'uid': instance.uid,
      'count': instance.count,
      'messages': instance.messages?.map((e) => e?.toJson())?.toList(),
      'createdAt': instance.createdAt == null
          ? null
          : Chat._dateTimeDoNothingSerializer(instance.createdAt)
    };

ChatMessage _$ChatMessageFromJson(Map json) {
  return ChatMessage(
      uid: json['uid'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : ChatMessage._dateTimeDoNothingSerializer(
              json['createdAt'] as DateTime),
      content: json['content'] as String);
}

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'createdAt': instance.createdAt == null
          ? null
          : ChatMessage._dateTimeDoNothingSerializer(instance.createdAt),
      'content': instance.content
    };
