import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact-list.g.dart';
@JsonSerializable()

class ContactList {
  final String uid;
  final int count;
  final List<Contact> contacts;
  
  //timestamps
  @JsonKey(fromJson: _dateTimeDoNothingSerializer, toJson: _dateTimeDoNothingSerializer)
  final DateTime createdAt;

  ContactList(
      {@required this.uid,
      @required this.count,
      @required this.createdAt,
      @required this.contacts});
  
  factory ContactList.fromJson(Map<String, dynamic> json) => _$ContactListFromJson(json);
  Map<String, dynamic> toJson() => _$ContactListToJson(this);

  static DateTime _dateTimeDoNothingSerializer(DateTime dt) =>
      dt;
}

@JsonSerializable()
class Contact{
  final String id;
  final String name;
  final String email;
  final String photoURL;
  final String phoneNumber;
  final Map<String, dynamic> metadata;

  Contact({
    this.id,
    @required this.name,
    @required this.email,
    this.photoURL,
    this.phoneNumber,
    this.metadata
   });

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);

}
