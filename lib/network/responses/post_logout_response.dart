import 'package:json_annotation/json_annotation.dart';

part 'post_logout_response.g.dart';

@JsonSerializable()
class PostLogoutResponse{
  @JsonKey(name: "message")
  String message;

  PostLogoutResponse(this.message);

  factory PostLogoutResponse.fromJson(Map<String, dynamic> json) => _$PostLogoutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostLogoutResponseToJson(this);
}