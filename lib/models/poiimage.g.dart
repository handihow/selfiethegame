// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poiimage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoiImage _$PoiImageFromJson(Map json) {
  return PoiImage(
    url: json['url'] as String,
    height: (json['height'] as num)?.toDouble(),
    width: (json['width'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PoiImageToJson(PoiImage instance) => <String, dynamic>{
      'url': instance.url,
      'height': instance.height,
      'width': instance.width,
    };
