import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import './rating.dart';
import './reaction-type.dart';

part 'reaction.g.dart';

@JsonSerializable()
class Reaction {
  final String id;
  final String comment;
  final String userDisplayName;
  final String userId;
  final String imageId;
  final String gameId;
  final String teamId;
  final String assignmentId;
  final ReactionType reactionType;
  final Rating rating;
  final String assignment;
  final String teamName;

  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime created;
  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime updated;

  Reaction({
    @required this.id,
    this.comment,
    @required this.userDisplayName,
    @required this.userId,
    @required this.imageId,
    @required this.gameId,
    @required this.teamId,
    @required this.assignmentId,
    @required this.reactionType,
    this.rating,
    @required this.assignment,
    @required this.teamName,
    @required this.created,
    @required this.updated,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);
  Map<String, dynamic> toJson() => _$ReactionToJson(this);

  static DateTime _dateTimeDoNothingSerializer(DateTime dt) => dt;

  static DateTime _timestampToDateSerializer(dt) {
    try {
      //this works on iOS
      return dt.toDate();
    } catch (e) {
      //this works on Android
      return dt;
    }
  }
}
