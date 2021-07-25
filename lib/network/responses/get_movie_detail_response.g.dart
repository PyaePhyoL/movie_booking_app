// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_movie_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMovieDetailResponse _$GetMovieDetailResponseFromJson(
    Map<String, dynamic> json) {
  return GetMovieDetailResponse(
    json['data'] == null
        ? null
        : MovieVO.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GetMovieDetailResponseToJson(
        GetMovieDetailResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
