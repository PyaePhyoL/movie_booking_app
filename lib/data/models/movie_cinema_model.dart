import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/date_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/data/vos/receipt_vo.dart';
import 'package:movie_booking_app/data/vos/seat_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';
import 'package:movie_booking_app/network/requests/checkout_request.dart';
import 'package:movie_booking_app/network/requests/snack_request.dart';

abstract class MovieCinemaModel{
  void getMovieList(String status);
  void getMovieDetail(int movieId);
  void getCinemaDayTimeslot(String date);
  Future<List<List<SeatVO>>> getCinemaSeatingPlan(int cinemaDayTimeslotId, String bookingDate);
  void getSnackList();
  Future<List<PaymentMethodVO>> getPaymentMethodList();
  Future<List<CardVO>> postCreateCard(String cardNumber, String cardHolder, String expirationDate, String cvc);
  Future<VoucherVO> postCheckout(ReceiptVO receipt);
  Future<VoucherVO> checkOut(CheckoutRequest checkoutRequest);

  CheckoutRequest checkoutRequest = CheckoutRequest();


  /// Database

  Future<List<MovieVO>> getCurrentMoviesFromDatabase();
  Future<List<MovieVO>> getComingSoonMoviesFromDatabase();
  Future<MovieVO> getMovieDetailFromDatabase(int movieId);
  Future<List<SnackVO>> getSnacksFromDatabase();
  Future<List<CinemaVO>> getCinemasByDateFromDatabase(String date);

  List<DateVO> getDates();
}