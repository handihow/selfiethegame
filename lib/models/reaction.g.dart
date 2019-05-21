// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaction _$ReactionFromJson(Map json) {
  return Reaction(
      id: json['id'] as String,
      comment: json['comment'] as String,
      userDisplayName: json['userDisplayName'] as String,
      userId: json['userId'] as String,
      imageId: json['imageId'] as String,
      gameId: json['gameId'] as String,
      teamId: json['teamId'] as String,
      assignmentId: json['assignmentId'] as String,
      reactionType:
          _$enumDecodeNullable(_$ReactionTypeEnumMap, json['reactionType']),
      rating: _$enumDecodeNullable(_$RatingEnumMap, json['rating']),
      assignment: json['assignment'] as String,
      teamName: json['teamName'] as String,
      created: json['created'] == null
          ? null
          : Reaction._timestampToDateSerializer(json['created']),
      updated: json['updated'] == null
          ? null
          : Reaction._timestampToDateSerializer(json['updated']));
}

Map<String, dynamic> _$ReactionToJson(Reaction instance) => <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'userDisplayName': instance.userDisplayName,
      'userId': instance.userId,
      'imageId': instance.imageId,
      'gameId': instance.gameId,
      'teamId': instance.teamId,
      'assignmentId': instance.assignmentId,
      'reactionType': _$ReactionTypeEnumMap[instance.reactionType],
      'rating': _$RatingEnumMap[instance.rating],
      'assignment': instance.assignment,
      'teamName': instance.teamName,
      'created': instance.created == null
          ? null
          : Reaction._dateTimeDoNothingSerializer(instance.created),
      'updated': instance.updated == null
          ? null
          : Reaction._dateTimeDoNothingSerializer(instance.updated)
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

const _$ReactionTypeEnumMap = <ReactionType, dynamic>{
  ReactionType.like: 0,
  ReactionType.comment: 1,
  ReactionType.rating: 2,
  ReactionType.inappropriate: 3
};

const _$RatingEnumMap = <Rating, dynamic>{
  Rating.invalid: 0,
  Rating.easy: 1,
  Rating.donotusebut: 2,
  Rating.medium: 3,
  Rating.iunderstandthisishacky: 4,
  Rating.hard: 5
};
