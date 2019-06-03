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
  final String downloadUrl;
  final String downloadUrlTN;
  final String assignmentId;
  final String assignment;
  final String gameId;
  final String userId;
  final String teamId;
  final String teamName;

  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime created;
  @JsonKey(
      fromJson: _timestampToDateSerializer,
      toJson: _dateTimeDoNothingSerializer)
  final DateTime updated;

  final int size;
  final String imageState;
  final Rating maxPoints;
  final List<String> likes; // user ids of people who liked the image
  final List<String> comments; // user ids of people who commented the image
  final List<String> ratings; // user ids of people who rated the image
  final List<String> abuses; // user ids of people who reported the image
  final Rating
      userAwardedPoints; // the awarded number of points of the user (calculated)

  ImageRef({
    @required this.id,
    this.pathOriginal,
    this.path,
    this.pathTN,
    this.downloadUrl,
    this.downloadUrlTN,
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
    this.likes,
    this.comments,
    this.ratings,
    this.abuses,
    this.userAwardedPoints,
  });

  factory ImageRef.fromJson(Map<String, dynamic> json) =>
      _$ImageRefFromJson(json);
  Map<String, dynamic> toJson() => _$ImageRefToJson(this);

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
