// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieVOAdapter extends TypeAdapter<MovieVO> {
  @override
  final int typeId = 4;

  @override
  MovieVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieVO(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      (fields[3] as List)?.cast<String>(),
      fields[4] as String,
      fields[5] as double,
      fields[6] as int,
      fields[7] as String,
      (fields[8] as List)?.cast<ActorVO>(),
      fields[9] as bool,
      fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MovieVO obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.originalTitle)
      ..writeByte(2)
      ..write(obj.releaseDate)
      ..writeByte(3)
      ..write(obj.genres)
      ..writeByte(4)
      ..write(obj.overview)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.runtime)
      ..writeByte(7)
      ..write(obj.posterPath)
      ..writeByte(8)
      ..write(obj.casts)
      ..writeByte(9)
      ..write(obj.isComingSoon)
      ..writeByte(10)
      ..write(obj.isCurrent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieVO _$MovieVOFromJson(Map<String, dynamic> json) {
  return MovieVO(
    json['id'] as int,
    json['original_title'] as String,
    json['release_date'] as String,
    (json['genres'] as List)?.map((e) => e as String)?.toList(),
    json['overview'] as String,
    (json['rating'] as num)?.toDouble(),
    json['runtime'] as int,
    json['poster_path'] as String,
    (json['casts'] as List)
        ?.map((e) =>
            e == null ? null : ActorVO.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['isComingSoon'] as bool,
    json['isCurrent'] as bool,
  );
}

Map<String, dynamic> _$MovieVOToJson(MovieVO instance) => <String, dynamic>{
      'id': instance.id,
      'original_title': instance.originalTitle,
      'release_date': instance.releaseDate,
      'genres': instance.genres,
      'overview': instance.overview,
      'rating': instance.rating,
      'runtime': instance.runtime,
      'poster_path': instance.posterPath,
      'casts': instance.casts,
      'isComingSoon': instance.isComingSoon,
      'isCurrent': instance.isCurrent,
    };
