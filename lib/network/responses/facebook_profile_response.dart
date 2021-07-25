import 'package:json_annotation/json_annotation.dart';

part 'facebook_profile_response.g.dart';

@JsonSerializable()
class FacebookProfileResponse{
  @JsonKey(name: "height")
  int height;

  @JsonKey(name: "is_silhouette")
  bool isSilhouette;

  @JsonKey(name: "url")
  String photoUrl;

  @JsonKey(name: "width")
  int width;

  FacebookProfileResponse(
      this.height, this.isSilhouette, this.photoUrl, this.width);


  @override
  String toString() {
    return 'FacebookProfileResponse{height: $height, isSilhouette: $isSilhouette, photoUrl: $photoUrl, width: $width}';
  }

  factory FacebookProfileResponse.fromJson(Map<String, dynamic> json) => _$FacebookProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FacebookProfileResponseToJson(this);
}