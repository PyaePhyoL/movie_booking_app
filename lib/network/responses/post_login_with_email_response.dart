import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';

part 'post_login_with_email_response.g.dart';

@JsonSerializable()
class PostLoginWithEmailResponse{
  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  UserVO data;

  @JsonKey(name: "token")
  String token;

  PostLoginWithEmailResponse(this.code, this.message, this.data, this.token);

  factory PostLoginWithEmailResponse.fromJson(Map<String, dynamic> json) => _$PostLoginWithEmailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostLoginWithEmailResponseToJson(this);
}