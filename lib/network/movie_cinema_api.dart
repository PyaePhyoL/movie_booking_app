import 'package:dio/dio.dart';
import 'package:movie_booking_app/data/vos/receipt_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/network/requests/checkout_request.dart';
import 'package:movie_booking_app/network/responses/get_cinema_day_timeslot_response.dart';
import 'package:movie_booking_app/network/responses/get_cinema_seating_plan_response.dart';
import 'package:movie_booking_app/network/responses/get_movie_detail_response.dart';
import 'package:movie_booking_app/network/responses/get_movie_list_response.dart';
import 'package:movie_booking_app/network/responses/get_payment_method_list_response.dart';
import 'package:movie_booking_app/network/responses/get_snack_list_response.dart';
import 'package:movie_booking_app/network/responses/get_user_profile_response.dart';
import 'package:movie_booking_app/network/responses/post_checkout_response.dart';
import 'package:movie_booking_app/network/responses/post_create_card_response.dart';
import 'package:movie_booking_app/network/responses/post_login_with_email_response.dart';
import 'package:movie_booking_app/network/responses/post_logout_response.dart';
import 'package:retrofit/http.dart';

part 'movie_cinema_api.g.dart';

@RestApi(baseUrl: BASE_URL_DIO)
abstract class MovieCinemaApi {
  factory MovieCinemaApi(Dio dio) = _MovieCinemaApi;

  @POST(ENDPOINT_LOG_IN_WITH_EMAIL)
  @FormUrlEncoded()
  Future<PostLoginWithEmailResponse> postLoginWithEmail(
    @Field(PARAM_EMAIL) String email,
    @Field(PARAM_PASSWORD) String password,
  );

  @POST(ENDPOINT_REGISTER_WITH_EMAIL)
  @FormUrlEncoded()
  Future<PostLoginWithEmailResponse> postRegisterWithEmail(
    @Field(PARAM_NAME) String name,
    @Field(PARAM_EMAIL) String email,
    @Field(PARAM_PASSWORD) String password,
    @Field(PARAM_PHONE) String phone, {
    @Field(PARAM_GOOGLE_ACCESS_TOKEN) String googleAccessToken,
    @Field(PARAM_FACEBOOK_ACCESS_TOKEN) String facebookAccessToken,
  });

  @GET(ENDPOINT_GET_MOVIE_LIST)
  Future<GetMovieListResponse> getMovieList(
    @Query(PARAM_STATUS) String status,
  );

  @POST(ENDPOINT_LOG_OUT)
  Future<PostLogoutResponse> postLogout(
    @Header(PARAM_AUTHORIZATION) String token,
  );

  @GET("$ENDPOINT_GET_MOVIE_DETAIL/{movie_id}")
  Future<GetMovieDetailResponse> getMovieDetail(
    @Path("movie_id") String movieId,
  );

  @GET(ENDPOINT_GET_CINEMA_DAY_TIMESLOT)
  Future<GetCinemaDayTimeslotResponse> getCinemaDayTimeslot(
    @Header(PARAM_AUTHORIZATION) String token,
    @Query(PARAM_DATE) String date,
  );

  @GET(ENDPOINT_GET_CINEMA_SEATING_PLAN)
  Future<GetCinemaSeatingPlanResponse> getCinemaSeatingPlan(
    @Header(PARAM_AUTHORIZATION) String token,
    @Query(PARAM_CINEMA_DAY_TIMESLOT_ID) String cinemaDayTimeslotId,
    @Query(PARAM_BOOKING_DATE) String bookingDate,
  );

  @GET(ENDPOINT_GET_SNACK_LIST)
  Future<GetSnackListResponse> getSnackList(
    @Header(PARAM_AUTHORIZATION) String token,
  );

  @GET(ENDPOINT_GET_PAYMENT_METHOD_LIST)
  Future<GetPaymentMethodListResponse> getPaymentMethodList(
    @Header(PARAM_AUTHORIZATION) String token,
  );

  @GET(ENDPOINT_GET_USER_PROFILE)
  Future<GetUserProfileResponse> getUserProfile(
    @Header(PARAM_AUTHORIZATION) String token,
  );

  @POST(ENDPOINT_POST_CREATE_CARD)
  Future<PostCreateCardResponse> postCreateCard(
    @Header(PARAM_AUTHORIZATION) String token,
    @Query(PARAM_CARD_NUMBER) String cardNumber,
    @Query(PARAM_CARD_HOLDER) String cardHolder,
    @Query(PARAM_EXPIRATION_DATE) String expirationDate,
    @Query(PARAM_CVC) String cvc,
  );

  @POST(ENDPOINT_POST_CHECKOUT)
  Future<PostCheckoutResponse> postCheckout(
    @Header(PARAM_AUTHORIZATION) String token,
    @Body() Map<String, dynamic> json,
  );

  @POST(ENDPOINT_POST_LOGIN_WITH_FACEBOOK)
  Future<PostLoginWithEmailResponse> postLoginWithFacebook(
    @Query(PARAM_ACCESS_TOKEN) String fbToken,
  );

  @POST(ENDPOINT_POST_LOGIN_WITH_GOOGLE)
  Future<PostLoginWithEmailResponse> postLoginWithGoogle(
    @Query(PARAM_ACCESS_TOKEN) String googleToken,
  );

  @POST(ENDPOINT_POST_CHECKOUT)
  Future<PostCheckoutResponse> checkOut(
      @Header(PARAM_AUTHORIZATION) String token,
      @Body() CheckoutRequest checkoutRequest);
}
