// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mask.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mask _$MaskFromJson(Map json) {
  return Mask(
    asset: json['asset'] as String,
    left: (json['left'] as num)?.toDouble(),
    top: (json['top'] as num)?.toDouble(),
    right: (json['right'] as num)?.toDouble(),
    bottom: (json['bottom'] as num)?.toDouble(),
    color: json['color'] as String,
  );
}

Map<String, dynamic> _$MaskToJson(Mask instance) => <String, dynamic>{
      'asset': instance.asset,
      'left': instance.left,
      'top': instance.top,
      'right': instance.right,
      'bottom': instance.bottom,
      'color': instance.color,
    };
