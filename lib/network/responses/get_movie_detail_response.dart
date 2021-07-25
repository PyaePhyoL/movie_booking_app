import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';

part 'get_movie_detail_response.g.dart';

@JsonSerializable()
class GetMovieDetailResponse{
  @JsonKey(name: "data")
  MovieVO data;

  GetMovieDetailResponse(this.data);

  factory GetMovieDetailResponse.fromJson(Map<String, dynamic> json) => _$GetMovieDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMovieDetailResponseToJson(this);
}