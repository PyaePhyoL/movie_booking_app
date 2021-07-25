// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facebook_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacebookProfileResponse _$FacebookProfileResponseFromJson(
    Map<String, dynamic> json) {
  return FacebookProfileResponse(
    json['height'] as int,
    json['is_silhouette'] as bool,
    json['url'] as String,
    json['width'] as int,
  );
}

Map<String, dynamic> _$FacebookProfileResponseToJson(
        FacebookProfileResponse instance) =>
    <String, dynamic>{
      'height': instance.height,
      'is_silhouette': instance.isSilhouette,
      'url': instance.photoUrl,
      'width': instance.width,
    };
