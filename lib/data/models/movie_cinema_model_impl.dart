import 'package:intl/intl.dart';
import 'package:movie_booking_app/data/models/auth_model.dart';
import 'package:movie_booking_app/data/models/auth_model.impl.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/date_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/data/vos/receipt_vo.dart';
import 'package:movie_booking_app/data/vos/seat_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/network/dataagents/movie_cinema_data_agent.dart';
import 'package:movie_booking_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:movie_booking_app/network/requests/checkout_request.dart';
import 'package:movie_booking_app/persistence/daos/cinema_dao.dart';
import 'package:movie_booking_app/persistence/daos/movie_dao.dart';
import 'package:movie_booking_app/persistence/daos/snack_dao.dart';
import 'package:stream_transform/stream_transform.dart';

class MovieCinemaModelImpl extends MovieCinemaModel {
  MovieCinemaDataAgent mDataAgent = RetrofitDataAgentImpl();
  AuthModel authModel = AuthModelImpl();

  static final MovieCinemaModelImpl _singleton =
      MovieCinemaModelImpl._internal();

  factory MovieCinemaModelImpl() {
    return _singleton;
  }

  MovieCinemaModelImpl._internal();

  MovieDao mMovieDao = MovieDao();
  SnackDao mSnackDao = SnackDao();
  CinemaDao mCinemaDao = CinemaDao();

  @override
  void getMovieList(String status) {
    if (status == CURRENT) {
      mDataAgent.getMovieList(status).then((movieList) async {
        List<MovieVO> currentMovies = movieList.map((movie) {
          movie.isCurrent = true;
          movie.isComingSoon = false;

          return movie;
        }).toList();

        mMovieDao.saveMovies(currentMovies);
      });
    } else if (status == COMING_SOON) {
      mDataAgent.getMovieList(status).then((movieList) async {
        List<MovieVO> comingSoonMovies = movieList.map((movie) {
          movie.isComingSoon = true;
          movie.isCurrent = false;

          return movie;
        }).toList();

        mMovieDao.saveMovies(comingSoonMovies);
      });
    }
  }

  @override
  void getMovieDetail(int movieId) {
    mDataAgent.getMovieDetail(movieId).then((movie) async {
      mMovieDao.saveSingleMovie(movie);
    });
  }

  @override
  void getCinemaDayTimeslot(String date) async {
    authModel.getTokenFromDatabase().then((token) =>
        mDataAgent.getCinemaDayTimeslot(token, date).then((cinemaList) {
          List<CinemaVO> mCinema = cinemaList;
          mCinema.forEach((cinema) {
            cinema.timeslots.forEach((time) {
              time.isSelected = false;
            });
          });
          mCinemaDao.saveCinemas(cinemaList, date);
        }));
  }

  @override
  Future<List<List<SeatVO>>> getCinemaSeatingPlan(
      int cinemaDayTimeslotId, String bookingDate) async {
    String bToken;

    await authModel.getTokenFromDatabase().then((token) {
      bToken = token;
    });

    return mDataAgent
        .getCinemaSeatingPlan(bToken, cinemaDayTimeslotId, bookingDate)
        .then((listOfSeatList) {
      List<List<SeatVO>> allSeats = listOfSeatList;

      allSeats.forEach((seatList) {
        seatList.forEach((seat) {
          if (seat.type == "available") seat.isSelected = false;
        });
      });

      return Future.value(allSeats);
    });
  }

  @override
  void getSnackList() async {
    authModel
        .getTokenFromDatabase()
        .then((token) => mDataAgent.getSnackList(token).then((snacks) {
              List<SnackVO> snackList = snacks;

              snackList.forEach((snack) {
                snack.qty = 0;
                snack.totalAmount = 0;
              });
              mSnackDao.saveSnacks(snackList);
            }));
  }

  @override
  Future<List<PaymentMethodVO>> getPaymentMethodList() async {
    String token;
    await authModel.getTokenFromDatabase().then((value) => token = value);

    return mDataAgent.getPaymentMethodList(token);
  }

  @override
  Future<List<CardVO>> postCreateCard(String cardNumber, String cardHolder,
      String expirationDate, String cvc) async {
    String token;
    await authModel.getTokenFromDatabase().then((value) => token = value);

    return mDataAgent.postCreateCard(
        token, cardNumber, cardHolder, expirationDate, cvc);
  }

  @override
  Future<VoucherVO> postCheckout(ReceiptVO receipt) async {
    String token;
    await authModel.getTokenFromDatabase().then((value) => token = value);

    return mDataAgent.postCheckout(token, receipt);
  }

  @override
  Future<VoucherVO> checkOut(CheckoutRequest checkoutRequest) async {
    String token;
    await authModel.getTokenFromDatabase().then((value) => token = value);

    return mDataAgent.checkOut(token, checkoutRequest);
  }

  /// Database

  @override
  Future<List<MovieVO>> getComingSoonMoviesFromDatabase() {
    this.getMovieList(COMING_SOON);
    return mMovieDao
        .getAllMoviesEventStream()
        .combineLatest(mMovieDao.getComingSoonMoviesStream(),
            (event, movieList) => movieList as List<MovieVO>)
        .first;
  }

  @override
  Future<List<MovieVO>> getCurrentMoviesFromDatabase() {
    this.getMovieList(CURRENT);
    return mMovieDao
        .getAllMoviesEventStream()
        .combineLatest(mMovieDao.getCurrentMoviesStream(),
            (event, movieList) => movieList as List<MovieVO>)
        .first;
  }

  @override
  Future<MovieVO> getMovieDetailFromDatabase(int movieId) async {
    this.getMovieDetail(movieId);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getMovieDetailStream(movieId))
        .combineLatest(mMovieDao.getMovieDetailStream(movieId),
            (event, movie) => movie as MovieVO)
        .first;
  }

  @override
  Future<List<SnackVO>> getSnacksFromDatabase() {
    this.getSnackList();
    return mSnackDao
        .getAllSnacksEventStream()
        .startWith(mSnackDao.getAllSnacksStream())
        .combineLatest(mSnackDao.getAllSnacksStream(),
            (event, snacks) => snacks as List<SnackVO>)
        .first;
  }

  /// Other
  @override
  List<DateVO> getDates() {
    List<DateVO> dateList = [];

    for (int i = 0; i < 7; i++) {
      String day = DateFormat.E().format(DateTime.now().add(Duration(days: i)));
      String date =
          DateFormat.d().format(DateTime.now().add(Duration(days: i)));
      String dayMonthDate =
          DateFormat.MMMMEEEEd().format(DateTime.now().add(Duration(days: i)));

      String yMd =
          DateFormat.yMd().format(DateTime.now().add(Duration(days: i)));

      var dateVo = DateVO(i, day, date, dayMonthDate, yMd);
      dateList.add(dateVo);
    }

    return dateList;
  }

  @override
  Future<List<CinemaVO>> getCinemasByDateFromDatabase(String date) {
    this.getCinemaDayTimeslot(date);
    return mCinemaDao
        .getCinemaEventStream()
        .combineLatest(mCinemaDao.getCinemasByDateStream(date),
            (event, cinemaList) => cinemaList as List<CinemaVO>)
        .first;
  }
}
