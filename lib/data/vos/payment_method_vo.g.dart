// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodVO _$PaymentMethodVOFromJson(Map<String, dynamic> json) {
  return PaymentMethodVO(
    json['id'] as int,
    json['name'] as String,
    json['description'] as String,
  );
}

Map<String, dynamic> _$PaymentMethodVOToJson(PaymentMethodVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
