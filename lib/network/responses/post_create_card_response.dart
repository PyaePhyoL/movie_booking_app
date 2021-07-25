import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';

part 'post_create_card_response.g.dart';

@JsonSerializable()
class PostCreateCardResponse{
  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  List<CardVO> data;

  PostCreateCardResponse(this.code, this.message, this.data);

  factory PostCreateCardResponse.fromJson(Map<String, dynamic> json) => _$PostCreateCardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostCreateCardResponseToJson(this);
}