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
  final int likes; // the number of likes on the image (calculated)
  final String userLikeId; // the like ID of the user (calculated)
  final int comments; // the number of comments on the image (calculated)
  final Rating
      userAwardedPoints; // the awarded number of points of the user (calculated)
  final String userRatingId; // the rating ID of the user (calculated)

  ImageRef(
      {@required this.id,
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
      this.likes,
      this.userLikeId,
      this.comments,
      this.userAwardedPoints,
      this.userRatingId});

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
