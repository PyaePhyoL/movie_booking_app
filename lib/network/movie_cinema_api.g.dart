// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_cinema_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _MovieCinemaApi implements MovieCinemaApi {
  _MovieCinemaApi(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://tmba.padc.com.mm';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<PostLoginWithEmailResponse> postLoginWithEmail(email, password) async {
    ArgumentError.checkNotNull(email, 'email');
    ArgumentError.checkNotNull(password, 'password');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'email': email, 'password': password};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>(
        '/api/v1/email-login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            contentType: 'application/x-www-form-urlencoded',
            baseUrl: baseUrl),
        data: _data);
    final value = PostLoginWithEmailResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<PostLoginWithEmailResponse> postRegisterWithEmail(
      name, email, password, phone,
      {googleAccessToken, facebookAccessToken}) async {
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(email, 'email');
    ArgumentError.checkNotNull(password, 'password');
    ArgumentError.checkNotNull(phone, 'phone');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'google-access-token': googleAccessToken,
      'facebook-access-token': facebookAccessToken
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/api/v1/register',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            contentType: 'application/x-www-form-urlencoded',
            baseUrl: baseUrl),
        data: _data);
    final value = PostLoginWithEmailResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<GetMovieListResponse> getMovieList(status) async {
    ArgumentError.checkNotNull(status, 'status');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'status': status};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/api/v1/movies',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = GetMovieListResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<PostLogoutResponse> postLogout(token) async {
    ArgumentError.checkNotNull(token, 'token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/api/v1/logout',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PostLogoutResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<GetMovieDetailResponse> getMovieDetail(movieId) async {
    ArgumentError.checkNotNull(movieId, 'movieId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        '/api/v1/movies/$movieId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = GetMovieDetailResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<GetCinemaDayTimeslotResponse> getCinemaDayTimeslot(token, date) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(date, 'date');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'date': date};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        '/api/v1/cinema-day-timeslots',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = GetCinemaDayTimeslotResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<GetCinemaSeatingPlanResponse> getCinemaSeatingPlan(
      token, cinemaDayTimeslotId, bookingDate) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(cinemaDayTimeslotId, 'cinemaDayTimeslotId');
    ArgumentError.checkNotNull(bookingDate, 'bookingDate');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'cinema_day_timeslot_id': cinemaDayTimeslotId,
      r'booking_date': bookingDate
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        '/api/v1/seat-plan',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = GetCinemaSeatingPlanResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<GetSnackListResponse> getSnackList(token) async {
    ArgumentError.checkNotNull(token, 'token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/api/v1/snacks',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = GetSnackListResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<GetPaymentMethodListResponse> getPaymentMethodList(token) async {
    ArgumentError.checkNotNull(token, 'token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        '/api/v1/payment-methods',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = GetPaymentMethodListResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<GetUserProfileResponse> getUserProfile(token) async {
    ArgumentError.checkNotNull(token, 'token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/api/v1/profile',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = GetUserProfileResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<PostCreateCardResponse> postCreateCard(
      token, cardNumber, cardHolder, expirationDate, cvc) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(cardNumber, 'cardNumber');
    ArgumentError.checkNotNull(cardHolder, 'cardHolder');
    ArgumentError.checkNotNull(expirationDate, 'expirationDate');
    ArgumentError.checkNotNull(cvc, 'cvc');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'card_number': cardNumber,
      r'card_holder': cardHolder,
      r'expiration_date': expirationDate,
      r'cvc': cvc
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/api/v1/card',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PostCreateCardResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<PostCheckoutResponse> postCheckout(token, json) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(json, 'json');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(json ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('/api/v1/checkout',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PostCheckoutResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<PostLoginWithEmailResponse> postLoginWithFacebook(fbToken) async {
    ArgumentError.checkNotNull(fbToken, 'fbToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'access-token': fbToken};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        '/api/v1/facebook-login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PostLoginWithEmailResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<PostLoginWithEmailResponse> postLoginWithGoogle(googleToken) async {
    ArgumentError.checkNotNull(googleToken, 'googleToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'access-token': googleToken};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        '/api/v1/google-login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PostLoginWithEmailResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<PostCheckoutResponse> checkOut(token, checkoutRequest) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(checkoutRequest, 'checkoutRequest');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(checkoutRequest?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('/api/v1/checkout',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PostCheckoutResponse.fromJson(_result.data);
    return value;
  }
}
