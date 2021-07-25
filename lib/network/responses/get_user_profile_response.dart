import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';

part 'get_user_profile_response.g.dart';

@JsonSerializable()
class GetUserProfileResponse{
  @JsonKey(name: "data")
  UserVO data;

  GetUserProfileResponse(this.data);

  factory GetUserProfileResponse.fromJson(Map<String, dynamic> json) => _$GetUserProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserProfileResponseToJson(this);
}