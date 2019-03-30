import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import './rating.dart';

part 'image.g.dart';
@JsonSerializable()

class ImageRef {
  final String id;
  final String pathOriginal;
  final String path;
  final String pathTN;
  final String assignmentId;
  final String assignment;
  final String gameId;
  final String userId;
  final String teamId;
  final String teamName;

  @JsonKey(fromJson: _dateTimeDoNothingSerializer, toJson: _dateTimeDoNothingSerializer)
  final DateTime created;
  @JsonKey(fromJson: _dateTimeDoNothingSerializer, toJson: _dateTimeDoNothingSerializer)
  final DateTime updated;

  final int size;
  final String imageState;
  final Rating maxPoints;


  ImageRef({
    @required this.id,
    this.pathOriginal,
    this.path,
    this.pathTN,
    @required this.assignmentId,
    @required this.assignment,
    @required this.gameId,
    @required this.userId,
    @required this.teamId,
    @required this.teamName,
    @required this.created,
    @required this.updated,
    this.size,
    this.imageState,
    @required this.maxPoints,
  });

  factory ImageRef.fromJson(Map<String, dynamic> json) => _$ImageRefFromJson(json);
  Map<String, dynamic> toJson() => _$ImageRefToJson(this);

  static DateTime _dateTimeDoNothingSerializer(DateTime dt) =>
      dt;

}
