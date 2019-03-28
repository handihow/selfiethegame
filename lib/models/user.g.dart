// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String,
      authMethod: _$enumDecodeNullable(_$AuthMethodEnumMap, json['authMethod']),
      participating:
          (json['participating'] as List)?.map((e) => e as String)?.toList(),
      playing: (json['playing'] as List)?.map((e) => e as String)?.toList(),
      judging: (json['judging'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'authMethod': _$AuthMethodEnumMap[instance.authMethod],
      'participating': instance.participating,
      'playing': instance.playing,
      'judging': instance.judging
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$AuthMethodEnumMap = <AuthMethod, dynamic>{
  AuthMethod.email: 0,
  AuthMethod.google: 1,
  AuthMethod.facebook: 2,
  AuthMethod.twitter: 3,
  AuthMethod.unknown: 4
};
