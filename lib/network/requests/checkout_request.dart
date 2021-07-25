import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/network/requests/snack_request.dart';

part 'checkout_request.g.dart';

@JsonSerializable()
class CheckoutRequest{
  @JsonKey(name: "cinema_day_timeslot_id")
  int cinemaDayTimeslotId;

  @JsonKey(name: "seat_number")
  String seatNumber;

  @JsonKey(name: "booking_date")
  String bookingDate;

  @JsonKey(name: "movie_id")
  int movieId;

  @JsonKey(name: "card_id")
  int cardId;

  @JsonKey(name: "snacks")
  List<SnackRequest> snacks;

  CheckoutRequest(
      {this.cinemaDayTimeslotId,
      this.seatNumber,
      this.bookingDate,
      this.movieId,
      this.cardId,
      this.snacks});


  @override
  String toString() {
    return 'CheckoutRequest{cinemaDayTimeslotId: $cinemaDayTimeslotId, seatNumber: $seatNumber, bookingDate: $bookingDate, movieId: $movieId, cardId: $cardId, snacks: $snacks}';
  }

  factory CheckoutRequest.fromJson(Map<String, dynamic> json) => _$CheckoutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutRequestToJson(this);
}
