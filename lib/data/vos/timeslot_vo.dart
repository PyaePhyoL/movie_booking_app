import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

part 'timeslot_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_TIMESLOT_VO, adapterName: "TimeslotVOAdapter")
class TimeslotVO{
  @JsonKey(name: "cinema_day_timeslot_id")
  @HiveField(0)
  int cinemaDayTimeslotId;

  @JsonKey(name: "start_time")
  @HiveField(1)
  String startTime;

  @HiveField(2)
  bool isSelected;

  TimeslotVO(this.cinemaDayTimeslotId, this.startTime, this.isSelected);

  factory TimeslotVO.fromJson(Map<String, dynamic> json) => _$TimeslotVOFromJson(json);

  Map<String, dynamic> toJson() => _$TimeslotVOToJson(this);
}