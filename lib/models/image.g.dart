// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageRef _$ImageRefFromJson(Map json) {
  return ImageRef(
      id: json['id'] as String,
      pathOriginal: json['pathOriginal'] as String,
      path: json['path'] as String,
      pathTN: json['pathTN'] as String,
      assignmentId: json['assignmentId'] as String,
      assignment: json['assignment'] as String,
      gameId: json['gameId'] as String,
      userId: json['userId'] as String,
      teamId: json['teamId'] as String,
      teamName: json['teamName'] as String,
      created: json['created'] == null
          ? null
          : ImageRef._timestampToDateSerializer(json['created']),
      updated: json['updated'] == null
          ? null
          : ImageRef._timestampToDateSerializer(json['updated']),
      size: json['size'] as int,
      imageState: json['imageState'] as String,
      maxPoints: _$enumDecodeNullable(_$RatingEnumMap, json['maxPoints']),
      likes: json['likes'] as int,
      userLikeId: json['userLikeId'] as String,
      comments: json['comments'] as int,
      userAwardedPoints:
          _$enumDecodeNullable(_$RatingEnumMap, json['userAwardedPoints']),
      userRatingId: json['userRatingId'] as String);
}

Map<String, dynamic> _$ImageRefToJson(ImageRef instance) => <String, dynamic>{
      'id': instance.id,
      'pathOriginal': instance.pathOriginal,
      'path': instance.path,
      'pathTN': instance.pathTN,
      'assignmentId': instance.assignmentId,
      'assignment': instance.assignment,
      'gameId': instance.gameId,
      'userId': instance.userId,
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'created': instance.created == null
          ? null
          : ImageRef._dateTimeDoNothingSerializer(instance.created),
      'updated': instance.updated == null
          ? null
          : ImageRef._dateTimeDoNothingSerializer(instance.updated),
      'size': instance.size,
      'imageState': instance.imageState,
      'maxPoints': _$RatingEnumMap[instance.maxPoints],
      'likes': instance.likes,
      'userLikeId': instance.userLikeId,
      'comments': instance.comments,
      'userAwardedPoints': _$RatingEnumMap[instance.userAwardedPoints],
      'userRatingId': instance.userRatingId
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
