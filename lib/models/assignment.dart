import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import './rating.dart';

part 'assignment.g.dart';

@JsonSerializable()
class Assignment {
  final String id;
  final String assignment;
  final int order;
  final String theme;
  final bool isOutside;
  final int level;
  final String gameId;
  final Rating maxPoints;
  final String description;
  final String location;
  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime created;
  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime updated;

  Assignment(
      {@required this.id,
      @required this.assignment,
      @required this.order,
      this.theme,
      this.isOutside,
      this.level,
      @required this.gameId,
      @required this.maxPoints,
      this.description,
      this.location,
      @required this.created,
      @required this.updated});

  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssignmentToJson(this);

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
