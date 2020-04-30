// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map json) {
  return Game(
    id: json['id'] as String,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
    code: json['code'] as String,
    status: json['status'] == null
        ? null
        : Status.fromJson((json['status'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    date: Game._timestampToDateSerializer(json['date']),
    duration: json['duration'] as int,
    created: Game._timestampToDateSerializer(json['created']),
    updated: Game._timestampToDateSerializer(json['updated']),
    administrator: json['administrator'] as String,
    judges: (json['judges'] as List)?.map((e) => e as String)?.toList(),
    players: (json['players'] as List)?.map((e) => e as String)?.toList(),
    participants:
        (json['participants'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'code': instance.code,
      'status': instance.status?.toJson(),
      'date': Game._dateTimeDoNothingSerializer(instance.date),
      'duration': instance.duration,
      'created': Game._dateTimeDoNothingSerializer(instance.created),
      'updated': Game._dateTimeDoNothingSerializer(instance.updated),
      'administrator': instance.administrator,
      'judges': instance.judges,
      'players': instance.players,
      'participants': instance.participants,
    };

Status _$StatusFromJson(Map json) {
  return Status(
    created: json['created'] as bool,
    invited: json['invited'] as bool,
    judgesAssigned: json['judgesAssigned'] as bool,
    teamsCreated: json['teamsCreated'] as bool,
    assigned: json['assigned'] as bool,
    closedAdmin: json['closedAdmin'] as bool,
    playing: json['playing'] as bool,
    pauzed: json['pauzed'] as bool,
    finished: json['finished'] as bool,
  );
}

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'created': instance.created,
      'invited': instance.invited,
      'judgesAssigned': instance.judgesAssigned,
      'teamsCreated': instance.teamsCreated,
      'assigned': instance.assigned,
      'closedAdmin': instance.closedAdmin,
      'playing': instance.playing,
      'pauzed': instance.pauzed,
      'finished': instance.finished,
    };
