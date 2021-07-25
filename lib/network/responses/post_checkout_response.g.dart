// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_checkout_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCheckoutResponse _$PostCheckoutResponseFromJson(Map<String, dynamic> json) {
  return PostCheckoutResponse(
    json['code'] as int,
    json['message'] as String,
    json['data'] == null
        ? null
        : VoucherVO.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PostCheckoutResponseToJson(
        PostCheckoutResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
