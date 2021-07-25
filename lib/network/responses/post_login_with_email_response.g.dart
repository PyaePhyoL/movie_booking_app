// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_login_with_email_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostLoginWithEmailResponse _$PostLoginWithEmailResponseFromJson(
    Map<String, dynamic> json) {
  return PostLoginWithEmailResponse(
    json['code'] as int,
    json['message'] as String,
    json['data'] == null
        ? null
        : UserVO.fromJson(json['data'] as Map<String, dynamic>),
    json['token'] as String,
  );
}

Map<String, dynamic> _$PostLoginWithEmailResponseToJson(
        PostLoginWithEmailResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
      'token': instance.token,
    };
