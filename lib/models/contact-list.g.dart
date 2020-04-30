// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact-list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactList _$ContactListFromJson(Map json) {
  return ContactList(
    uid: json['uid'] as String,
    count: json['count'] as int,
    createdAt: ContactList._timestampToDateSerializer(json['createdAt']),
    contacts: (json['contacts'] as List)
        ?.map((e) => e == null
            ? null
            : Contact.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$ContactListToJson(ContactList instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'count': instance.count,
      'contacts': instance.contacts?.map((e) => e?.toJson())?.toList(),
      'createdAt': ContactList._dateTimeDoNothingSerializer(instance.createdAt),
    };

Contact _$ContactFromJson(Map json) {
  return Contact(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    photoURL: json['photoURL'] as String,
    phoneNumber: json['phoneNumber'] as String,
    metadata: (json['metadata'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
  );
}

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photoURL': instance.photoURL,
      'phoneNumber': instance.phoneNumber,
      'metadata': instance.metadata,
    };
