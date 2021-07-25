import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';

part 'receipt_vo.g.dart';

@JsonSerializable()
class ReceiptVO{
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
  List<Map<String, dynamic>> snacks;


  ReceiptVO(
      {this.cinemaDayTimeslotId,
      this.seatNumber,
      this.bookingDate,
      this.movieId,
      this.cardId,
      this.snacks});


  @override
  String toString() {
    return 'ReceiptVO{cinemaDayTimeslotId: $cinemaDayTimeslotId, seatNumber: $seatNumber, bookingDate: $bookingDate, movieId: $movieId, cardId: $cardId, snacks: $snacks}';
  }

  factory ReceiptVO.fromJson(Map<String, dynamic> json) => _$ReceiptVOFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptVOToJson(this);
}

