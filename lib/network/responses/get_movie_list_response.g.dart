// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_movie_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMovieListResponse _$GetMovieListResponseFromJson(Map<String, dynamic> json) {
  return GetMovieListResponse(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : MovieVO.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GetMovieListResponseToJson(
        GetMovieListResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
