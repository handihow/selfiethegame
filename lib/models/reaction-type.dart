import 'package:json_annotation/json_annotation.dart';

enum ReactionType {
  @JsonValue(0)
  like, 
  @JsonValue(1)
  comment,
  @JsonValue(2)
  rating,

}