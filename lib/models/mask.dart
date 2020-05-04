import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mask.g.dart';
@JsonSerializable()

class Mask {
  final String asset;
  final double left;
  final double top;
  final double right;
  final double bottom;
  final String color;

  Mask({
    @required this.asset,
    @required this.left,
    @required this.top,
    @required this.right,
    @required this.bottom,
    this.color
  });

  factory Mask.fromJson(Map<String, dynamic> json) => _$MaskFromJson(json);
  Map<String, dynamic> toJson() => _$MaskToJson(this);

}

