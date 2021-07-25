import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/network/responses/facebook_data_response.dart';

part 'facebook_response.g.dart';

@JsonSerializable()
class FacebookResponse {
  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "picture")
  FacebookDataResponse picture;

  @JsonKey(name: "email")
  String email;

  @JsonKey(name: "id")
  String id;

  FacebookResponse(this.name, this.email, this.picture, this.id);


  @override
  String toString() {
    return 'FacebookResponse{name: $name, data: $picture, email: $email, id: $id}';
  }

  factory FacebookResponse.fromJson(Map<String, dynamic> json) =>
      _$FacebookResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FacebookResponseToJson(this);
}
