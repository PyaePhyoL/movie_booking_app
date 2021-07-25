import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/data/vos/receipt_vo.dart';
import 'package:movie_booking_app/data/vos/seat_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';
import 'package:movie_booking_app/network/requests/checkout_request.dart';

abstract class MovieCinemaDataAgent {
  String token;

  Future<UserVO> postLoginWithEmail(String email, String password);

  Future<UserVO> postRegisterWithEmail(
    String name,
    String email,
    String password,
    String phone,
      {
    String fbAccessToken,
        String googleAccessToken,
  });

  Future<List<MovieVO>> getMovieList(String status);

  Future<String> postLogout(String token);

  Future<MovieVO> getMovieDetail(int movieId);

  Future<List<CinemaVO>> getCinemaDayTimeslot(String token, String date);

  Future<List<List<SeatVO>>> getCinemaSeatingPlan(String token, int cinemaDayTimeslotId, String bookingDate);

  Future<List<SnackVO>> getSnackList(String token);

  Future<List<PaymentMethodVO>> getPaymentMethodList(String token);

  Future<UserVO> getUserProfile(String token);

  Future<List<CardVO>> postCreateCard(String token, String cardNumber, String cardHolder, String expirationDate, String cvc);

  Future<VoucherVO> postCheckout(String token, ReceiptVO receipt);

  Future<VoucherVO> checkOut(String token, CheckoutRequest checkoutRequest);

  Future<UserVO> postLoginWithFacebook(String token);

  Future<UserVO> postLoginWithGoogle(String token);
}
