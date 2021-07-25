import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/network/responses/facebook_profile_response.dart';

part 'facebook_data_response.g.dart';

@JsonSerializable()
class FacebookDataResponse{
  @JsonKey(name: "data")
  FacebookProfileResponse data;

  FacebookDataResponse(this.data);


  @override
  String toString() {
    return 'FacebookDataResponse{data: $data}';
  }

  factory FacebookDataResponse.fromJson(Map<String, dynamic> json) => _$FacebookDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FacebookDataResponseToJson(this);
}