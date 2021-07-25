import 'package:movie_booking_app/resources/strings.dart';

class MovieSeatVO {
  String title;
  String type;

  MovieSeatVO({this.title, this.type});

  bool isMovieSeatAvailable() {
    return this.type == SEAT_TYPE_AVAILABLE;
  }

  bool isMovieSeatTaken() {
    return this.type == SEAT_TYPE_TAKEN;
  }

  bool isMovieSeatRowTitle() {
    return this.type == SEAT_TYPE_TEXT;
  }
}