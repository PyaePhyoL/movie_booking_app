import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/seat_vo.dart';

part 'get_cinema_seating_plan_response.g.dart';

@JsonSerializable()
class GetCinemaSeatingPlanResponse {
  @JsonKey(name: "data")
  List<List<SeatVO>> data;

  GetCinemaSeatingPlanResponse(this.data);

 factory GetCinemaSeatingPlanResponse.fromJson(Map<String, dynamic> json) => _$GetCinemaSeatingPlanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCinemaSeatingPlanResponseToJson(this);
}
