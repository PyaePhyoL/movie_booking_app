// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_create_card_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCreateCardResponse _$PostCreateCardResponseFromJson(
    Map<String, dynamic> json) {
  return PostCreateCardResponse(
    json['code'] as int,
    json['message'] as String,
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : CardVO.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostCreateCardResponseToJson(
        PostCreateCardResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
