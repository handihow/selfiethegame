import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class Game {
  final String id;
  final String name;
  final String imageUrl;
  final String code;
  final Status status;

  //timestamps
  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime date;
  final int duration;
  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime created;
  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime updated;

  //different user level user Ids
  final String administrator;
  final List<String> judges;
  final List<String> players;
  final List<String> participants;

  Game(
      {this.id,
      @required this.name,
      @required this.imageUrl,
      @required this.code,
      @required this.status,
      @required this.date,
      this.duration,
      @required this.created,
      @required this.updated,
      @required this.administrator,
      this.judges,
      this.players,
      this.participants});

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);

  static DateTime _dateTimeDoNothingSerializer(DateTime dt) => dt;

  static DateTime _timestampToDateSerializer(dt) {
    try{
      //this works on iOS
      return dt.toDate();
    } catch(e) {
      //this works on Android
      return dt;
    }
  }

}

@JsonSerializable()
class Status {
  bool created;
  bool invited;
  bool judgesAssigned;
  bool teamsCreated;
  bool assigned;
  bool closedAdmin;
  bool playing;
  bool pauzed;
  bool finished;

  Status(
      {@required this.created,
      @required this.invited,
      @required this.judgesAssigned,
      @required this.teamsCreated,
      @required this.assigned,
      @required this.closedAdmin,
      @required this.playing,
      @required this.pauzed,
      @required this.finished});

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
  Map<String, dynamic> toJson() => _$StatusToJson(this);
}
