// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeslot_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeslotVOAdapter extends TypeAdapter<TimeslotVO> {
  @override
  final int typeId = 8;

  @override
  TimeslotVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeslotVO(
      fields[0] as int,
      fields[1] as String,
      fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TimeslotVO obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.cinemaDayTimeslotId)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeslotVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeslotVO _$TimeslotVOFromJson(Map<String, dynamic> json) {
  return TimeslotVO(
    json['cinema_day_timeslot_id'] as int,
    json['start_time'] as String,
    json['isSelected'] as bool,
  );
}

Map<String, dynamic> _$TimeslotVOToJson(TimeslotVO instance) =>
    <String, dynamic>{
      'cinema_day_timeslot_id': instance.cinemaDayTimeslotId,
      'start_time': instance.startTime,
      'isSelected': instance.isSelected,
    };
