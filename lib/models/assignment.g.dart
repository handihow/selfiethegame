// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assignment _$AssignmentFromJson(Map json) {
  return Assignment(
      id: json['id'] as String,
      assignment: json['assignment'] as String,
      order: json['order'] as int,
      theme: json['theme'] as String,
      isOutside: json['isOutside'] as bool,
      level: json['level'] as int,
      gameId: json['gameId'] as String,
      maxPoints: json['maxPoints'] as int,
      created: json['created'] == null
          ? null
          : Assignment._dateTimeDoNothingSerializer(
              json['created'] as DateTime),
      updated: json['updated'] == null
          ? null
          : Assignment._dateTimeDoNothingSerializer(
              json['updated'] as DateTime));
}

Map<String, dynamic> _$AssignmentToJson(Assignment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assignment': instance.assignment,
      'order': instance.order,
      'theme': instance.theme,
      'isOutside': instance.isOutside,
      'level': instance.level,
      'gameId': instance.gameId,
      'maxPoints': instance.maxPoints,
      'created': instance.created == null
          ? null
          : Assignment._dateTimeDoNothingSerializer(instance.created),
      'updated': instance.updated == null
          ? null
          : Assignment._dateTimeDoNothingSerializer(instance.updated)
    };
