// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_cinema_seating_plan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCinemaSeatingPlanResponse _$GetCinemaSeatingPlanResponseFromJson(
    Map<String, dynamic> json) {
  return GetCinemaSeatingPlanResponse(
    (json['data'] as List)
        ?.map((e) => (e as List)
            ?.map((e) =>
                e == null ? null : SeatVO.fromJson(e as Map<String, dynamic>))
            ?.toList())
        ?.toList(),
  );
}

Map<String, dynamic> _$GetCinemaSeatingPlanResponseToJson(
        GetCinemaSeatingPlanResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
