import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'poiimage.g.dart';
@JsonSerializable()

class PoiImage {
  final String url;
  final double height;
  final double width;

  PoiImage({
    @required this.url,
    @required this.height,
    @required this.width
  });

  factory PoiImage.fromJson(Map<String, dynamic> json) => _$PoiImageFromJson(json);
  Map<String, dynamic> toJson() => _$PoiImageToJson(this);

}

