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
      maxPoints: _$enumDecodeNullable(_$RatingEnumMap, json['maxPoints']),
      description: json['description'] as String,
      location: json['location'] as String,
      created: json['created'] == null
          ? null
          : Assignment._timestampToDateSerializer(json['created']),
      updated: json['updated'] == null
          ? null
          : Assignment._timestampToDateSerializer(json['updated']));
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
      'maxPoints': _$RatingEnumMap[instance.maxPoints],
      'description': instance.description,
      'location': instance.location,
      'created': instance.created == null
          ? null
          : Assignment._dateTimeDoNothingSerializer(instance.created),
      'updated': instance.updated == null
          ? null
          : Assignment._dateTimeDoNothingSerializer(instance.updated)
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$RatingEnumMap = <Rating, dynamic>{
  Rating.invalid: 0,
  Rating.easy: 1,
  Rating.donotusebut: 2,
  Rating.medium: 3,
  Rating.iunderstandthisishacky: 4,
  Rating.hard: 5
};
