// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facebook_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacebookResponse _$FacebookResponseFromJson(Map<String, dynamic> json) {
  return FacebookResponse(
    json['name'] as String,
    json['email'] as String,
    json['picture'] == null
        ? null
        : FacebookDataResponse.fromJson(
            json['picture'] as Map<String, dynamic>),
    json['id'] as String,
  );
}

Map<String, dynamic> _$FacebookResponseToJson(FacebookResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'picture': instance.picture,
      'email': instance.email,
      'id': instance.id,
    };
