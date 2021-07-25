import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';

part 'post_checkout_response.g.dart';

@JsonSerializable()
class PostCheckoutResponse{
  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  VoucherVO data;

  PostCheckoutResponse(this.code, this.message, this.data);

  factory PostCheckoutResponse.fromJson(Map<String, dynamic> json) => _$PostCheckoutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostCheckoutResponseToJson(this);
}