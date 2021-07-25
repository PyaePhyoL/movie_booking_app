// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserProfileResponse _$GetUserProfileResponseFromJson(
    Map<String, dynamic> json) {
  return GetUserProfileResponse(
    json['data'] == null
        ? null
        : UserVO.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GetUserProfileResponseToJson(
        GetUserProfileResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
