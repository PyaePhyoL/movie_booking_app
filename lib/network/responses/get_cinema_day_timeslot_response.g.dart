// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_cinema_day_timeslot_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCinemaDayTimeslotResponse _$GetCinemaDayTimeslotResponseFromJson(
    Map<String, dynamic> json) {
  return GetCinemaDayTimeslotResponse(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : CinemaVO.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GetCinemaDayTimeslotResponseToJson(
        GetCinemaDayTimeslotResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
