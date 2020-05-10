import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import './rating.dart';
import './poiimage.dart';

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
  //google places location
  final bool hasGooglePlacesLocation;
  final double latitude;
  final double longitude;
  // final String formatted_address;
  final String name;
  final List<PoiImage> photos;
  // final String place_id;
  final double rating;
  final String reference;
  final String url;
  // final int user_ratings_total;
  final String vicinity;
  final String website;

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
      @required this.updated,
      this.hasGooglePlacesLocation,
      this.latitude,
      this.longitude,
      // this.formatted_address,
      this.name,
      this.photos,
      // this.place_id,
      this.rating,
      this.reference,
      this.url,
      // this.user_ratings_total,
      this.vicinity,
      this.website
  });

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
