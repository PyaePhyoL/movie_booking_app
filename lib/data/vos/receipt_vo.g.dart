// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptVO _$ReceiptVOFromJson(Map<String, dynamic> json) {
  return ReceiptVO(
    cinemaDayTimeslotId: json['cinema_day_timeslot_id'] as int,
    seatNumber: json['seat_number'] as String,
    bookingDate: json['booking_date'] as String,
    movieId: json['movie_id'] as int,
    cardId: json['card_id'] as int,
    snacks: (json['snacks'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList(),
  );
}

Map<String, dynamic> _$ReceiptVOToJson(ReceiptVO instance) => <String, dynamic>{
      'cinema_day_timeslot_id': instance.cinemaDayTimeslotId,
      'seat_number': instance.seatNumber,
      'booking_date': instance.bookingDate,
      'movie_id': instance.movieId,
      'card_id': instance.cardId,
      'snacks': instance.snacks,
    };
