// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_payment_method_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPaymentMethodListResponse _$GetPaymentMethodListResponseFromJson(
    Map<String, dynamic> json) {
  return GetPaymentMethodListResponse(
    (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : PaymentMethodVO.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GetPaymentMethodListResponseToJson(
        GetPaymentMethodListResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
