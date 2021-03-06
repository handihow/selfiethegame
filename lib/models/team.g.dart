// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map json) {
  return Team(
    id: json['id'] as String,
    name: json['name'] as String,
    order: json['order'] as int,
    color: json['color'] as String,
    gameId: json['gameId'] as String,
    members: (json['members'] as List)?.map((e) => e as String)?.toList(),
    memberDisplayNames:
        (json['memberDisplayNames'] as List)?.map((e) => e as String)?.toList(),
    progress: json['progress'] as int,
    rating: json['rating'] as int,
  );
}

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'color': instance.color,
      'gameId': instance.gameId,
      'members': instance.members,
      'memberDisplayNames': instance.memberDisplayNames,
      'progress': instance.progress,
      'rating': instance.rating,
    };
