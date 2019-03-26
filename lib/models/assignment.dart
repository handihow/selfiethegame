import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

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
  @JsonKey(fromJson: _dateTimeDoNothingSerializer, toJson: _dateTimeDoNothingSerializer)
  final DateTime created;
  @JsonKey(fromJson: _dateTimeDoNothingSerializer, toJson: _dateTimeDoNothingSerializer)
  final DateTime updated;

  Assignment({
    @required this.id,
    @required this.assignment,
    @required this.order,
    this.theme,
    this.isOutside,
    this.level,
    @required this.gameId,
    @required this.maxPoints,
    @required this.created,
    @required this.updated
  });

  factory Assignment.fromJson(Map<String, dynamic> json) => _$AssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssignmentToJson(this);

  static DateTime _dateTimeDoNothingSerializer(DateTime dt) =>
      dt;

}

enum Rating {
  @JsonValue(0)
  invalid, 
  @JsonValue(1)
  easy,
  @JsonValue(2)
  donotusebut,
  @JsonValue(3)
  medium,
  @JsonValue(4)
  iunderstandthisishacky,
  @JsonValue(5)
  hard

}

