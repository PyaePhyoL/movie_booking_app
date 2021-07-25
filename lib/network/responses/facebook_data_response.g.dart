// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facebook_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacebookDataResponse _$FacebookDataResponseFromJson(Map<String, dynamic> json) {
  return FacebookDataResponse(
    json['data'] == null
        ? null
        : FacebookProfileResponse.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FacebookDataResponseToJson(
        FacebookDataResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
