import 'package:json_annotation/json_annotation.dart';

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