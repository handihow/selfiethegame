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
    downloadUrl: json['downloadUrl'] as String,
    downloadUrlTN: json['downloadUrlTN'] as String,
    assignmentId: json['assignmentId'] as String,
    assignment: json['assignment'] as String,
    gameId: json['gameId'] as String,
    userId: json['userId'] as String,
    teamId: json['teamId'] as String,
    teamName: json['teamName'] as String,
    created: ImageRef._timestampToDateSerializer(json['created']),
    updated: ImageRef._timestampToDateSerializer(json['updated']),
    size: json['size'] as int,
    imageState: json['imageState'] as String,
    maxPoints: _$enumDecodeNullable(_$RatingEnumMap, json['maxPoints']),
    likes: (json['likes'] as List)?.map((e) => e as String)?.toList(),
    comments: (json['comments'] as List)?.map((e) => e as String)?.toList(),
    ratings: (json['ratings'] as List)?.map((e) => e as String)?.toList(),
    abuses: (json['abuses'] as List)?.map((e) => e as String)?.toList(),
    userAwardedPoints:
        _$enumDecodeNullable(_$RatingEnumMap, json['userAwardedPoints']),
    hasLocation: json['hasLocation'] as bool,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    hasMasks: json['hasMasks'] as bool,
    masks: (json['masks'] as List)
        ?.map((e) => e == null
            ? null
            : Mask.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$ImageRefToJson(ImageRef instance) => <String, dynamic>{
      'id': instance.id,
      'pathOriginal': instance.pathOriginal,
      'path': instance.path,
      'pathTN': instance.pathTN,
      'downloadUrl': instance.downloadUrl,
      'downloadUrlTN': instance.downloadUrlTN,
      'assignmentId': instance.assignmentId,
      'assignment': instance.assignment,
      'gameId': instance.gameId,
      'userId': instance.userId,
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'created': ImageRef._dateTimeDoNothingSerializer(instance.created),
      'updated': ImageRef._dateTimeDoNothingSerializer(instance.updated),
      'size': instance.size,
      'imageState': instance.imageState,
      'maxPoints': _$RatingEnumMap[instance.maxPoints],
      'likes': instance.likes,
      'comments': instance.comments,
      'ratings': instance.ratings,
      'abuses': instance.abuses,
      'userAwardedPoints': _$RatingEnumMap[instance.userAwardedPoints],
      'hasLocation': instance.hasLocation,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'hasMasks': instance.hasMasks,
      'masks': instance.masks?.map((e) => e?.toJson())?.toList(),
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
