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
    created: Assignment._timestampToDateSerializer(json['created']),
    updated: Assignment._timestampToDateSerializer(json['updated']),
  );
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
      'created': Assignment._dateTimeDoNothingSerializer(instance.created),
      'updated': Assignment._dateTimeDoNothingSerializer(instance.updated),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$RatingEnumMap = {
  Rating.invalid: 0,
  Rating.easy: 1,
  Rating.donotusebut: 2,
  Rating.medium: 3,
  Rating.iunderstandthisishacky: 4,
  Rating.hard: 5,
};
