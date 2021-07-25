import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/data/vos/receipt_vo.dart';
import 'package:movie_booking_app/data/vos/seat_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/network/dataagents/movie_cinema_data_agent.dart';
import 'package:movie_booking_app/network/movie_cinema_api.dart';
import 'package:movie_booking_app/network/requests/checkout_request.dart';
import 'package:movie_booking_app/network/responses/post_checkout_response.dart';

class RetrofitDataAgentImpl extends MovieCinemaDataAgent {
  MovieCinemaApi mApi;

  static final RetrofitDataAgentImpl _singleton =
      RetrofitDataAgentImpl._internal();

  factory RetrofitDataAgentImpl() {
    return _singleton;
  }

  RetrofitDataAgentImpl._internal() {
    final dio = Dio(
      BaseOptions(
        followRedirects: false,
        validateStatus: (status) {
          return status < 300;
        },
        headers: {
          "content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
      ),
    );
    mApi = MovieCinemaApi(dio);
  }

  @override
  Future<UserVO> postLoginWithEmail(String email, String password) {
    return mApi.postLoginWithEmail(email, password).asStream().map((response) {
      super.token = response.token;
      return response.data;
    }).first;
  }

  @override
  Future<UserVO> postRegisterWithEmail(
      String name, String email, String password, String phone,
      {String fbAccessToken, String googleAccessToken}) {
    return mApi
        .postRegisterWithEmail(name, email, password, phone,
            facebookAccessToken: fbAccessToken,
            googleAccessToken: googleAccessToken)
        .asStream()
        .map((response) {
      super.token = response.token;

      return response.data;
    }).first;
  }

  @override
  Future<List<MovieVO>> getMovieList(String status) {
    return mApi
        .getMovieList(status)
        .asStream()
        .map((response) => response.data)
        .first;
  }

  @override
  Future<String> postLogout(String token) {
    return mApi
        .postLogout(token)
        .asStream()
        .map((response) => response.message)
        .first;
  }

  @override
  Future<MovieVO> getMovieDetail(int movieId) {
    return mApi
        .getMovieDetail(movieId.toString())
        .asStream()
        .map((response) => response.data)
        .first;
  }

  @override
  Future<List<CinemaVO>> getCinemaDayTimeslot(String token, String date) {
    return mApi
        .getCinemaDayTimeslot(token, date)
        .asStream()
        .map((response) => response.data)
        .first;
  }

  @override
  Future<List<List<SeatVO>>> getCinemaSeatingPlan(
      String token, int cinemaDayTimeslotId, String bookingDate) {
    return mApi
        .getCinemaSeatingPlan(
            token, cinemaDayTimeslotId.toString(), bookingDate)
        .asStream()
        .map((response) => response.data)
        .first;
  }

  @override
  Future<List<SnackVO>> getSnackList(String token) {
    return mApi
        .getSnackList(token)
        .asStream()
        .map((response) => response.data)
        .first;
  }

  @override
  Future<List<PaymentMethodVO>> getPaymentMethodList(String token) {
    return mApi
        .getPaymentMethodList(token)
        .asStream()
        .map((response) => response.data)
        .first;
  }

  @override
  Future<UserVO> getUserProfile(String token) {
    return mApi
        .getUserProfile(token)
        .asStream()
        .map((response) => response.data)
        .first;
  }

  @override
  Future<List<CardVO>> postCreateCard(String token, String cardNumber,
      String cardHolder, String expirationDate, String cvc) {
    return mApi
        .postCreateCard(token, cardNumber, cardHolder, expirationDate, cvc)
        .asStream()
        .map((response) => response.data)
        .first;
  }

  @override
  Future<VoucherVO> postCheckout(String token, ReceiptVO receipt) {
    return mApi
        .postCheckout(token, receipt.toJson())
        .asStream()
        .map((response) => response.data)
        .first;
  }

  @override
  Future<UserVO> postLoginWithFacebook(String token) {
    return mApi.postLoginWithFacebook(token).asStream().map((response) {
      super.token = response.token;
      return response.data;
    }).first;
  }

  @override
  Future<UserVO> postLoginWithGoogle(String token) {
    return mApi.postLoginWithGoogle(token).asStream().map((response) {
      super.token = response.token;

      return response.data;
    }).first;
  }

  @override
  Future<VoucherVO> checkOut(String token, CheckoutRequest checkoutRequest) {
    return mApi
        .checkOut(token, checkoutRequest)
        .then((response) {
          if (response.code == RESPONSE_CODE_SUCCESS) {
            return Future<PostCheckoutResponse>.value(response);
          } else {
            return Future<PostCheckoutResponse>.error(response.message);
          }
        })
        .asStream()
        .map((response) => response.data)
        .first;
  }
}
