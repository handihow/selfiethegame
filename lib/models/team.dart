import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';
@JsonSerializable()

class Team {
  final String id;
  final String name;
  final int order;
  final String color;
  final String gameId;
  final List<String> members;
  final List<String> memberDisplayNames;
  final int progress;
  final int rating;

  Team({
    @required this.id,
    @required this.name,
    @required this.order,
    @required this.color,
    @required this.gameId,
    @required this.members,
    this.memberDisplayNames,
    @required this.progress,
    @required this.rating
  });

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);

}

