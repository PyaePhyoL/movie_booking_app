import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

class MovieDao {
  static final MovieDao _singleton = MovieDao._internal();

  factory MovieDao() {
    return _singleton;
  }

  MovieDao._internal();

  void saveMovies(List<MovieVO> movieList) async {
    Map<int, MovieVO> movieMap = Map.fromIterable(
      movieList,
      key: (movie) => movie.id,
      value: (movie) => movie,
    );

    await getMovieBox().putAll(movieMap);
  }

  void saveSingleMovie(MovieVO movie) async {
    await getMovieBox().put(movie.id, movie);
  }

  List<MovieVO> getAllMovies() {
    return getMovieBox().values.toList();
  }

  MovieVO getMovieById(int movieId) {
    return getMovieBox().get(movieId);
  }

  Box<MovieVO> getMovieBox() {
    return Hive.box<MovieVO>(BOX_NAME_MOVIE_VO);
  }

  /// Reactive
  Stream<void> getAllMoviesEventStream() {
    return getMovieBox().watch();
  }

  Stream<List<MovieVO>> getComingSoonMoviesStream() {
    return Stream.value(
        getAllMovies().where((movie) => movie.isComingSoon ?? true).toList());
  }

  Stream<List<MovieVO>> getCurrentMoviesStream() {
    return Stream.value(
        getAllMovies().where((movie) => movie.isCurrent ?? true).toList());
  }

  Stream<MovieVO> getMovieDetailStream(int movieId) {
    return Stream.value(getMovieById(movieId));
  }
}
