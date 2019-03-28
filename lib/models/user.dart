import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final AuthMethod authMethod;
  final List<String> participating;
  final List<String> playing;
  final List<String> judging;

  User(
      {@required this.uid,
      @required this.email,
      @required this.displayName,
      this.photoURL,
      @required this.authMethod,
      this.participating,
      this.playing,
      this.judging});

   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}

enum AuthMethod {
  @JsonValue(0)
  email, 
  @JsonValue(1)
  google, 
  @JsonValue(2)
  facebook, 
  @JsonValue(3)
  twitter, 
  @JsonValue(4)
  unknown
}
