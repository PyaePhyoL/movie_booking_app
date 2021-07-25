// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CinemaVOAdapter extends TypeAdapter<CinemaVO> {
  @override
  final int typeId = 6;

  @override
  CinemaVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CinemaVO(
      fields[0] as int,
      fields[1] as String,
      (fields[2] as List)?.cast<TimeslotVO>(),
      (fields[3] as Set)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CinemaVO obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cinemaId)
      ..writeByte(1)
      ..write(obj.cinema)
      ..writeByte(2)
      ..write(obj.timeslots)
      ..writeByte(3)
      ..write(obj.dates?.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CinemaVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaVO _$CinemaVOFromJson(Map<String, dynamic> json) {
  return CinemaVO(
    json['cinema_id'] as int,
    json['cinema'] as String,
    (json['timeslots'] as List)
        ?.map((e) =>
            e == null ? null : TimeslotVO.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['dates'] as List)?.map((e) => e as String)?.toSet(),
  );
}

Map<String, dynamic> _$CinemaVOToJson(CinemaVO instance) => <String, dynamic>{
      'cinema_id': instance.cinemaId,
      'cinema': instance.cinema,
      'timeslots': instance.timeslots,
      'dates': instance.dates?.toList(),
    };
