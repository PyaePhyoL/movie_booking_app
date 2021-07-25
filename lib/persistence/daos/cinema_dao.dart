import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

class CinemaDao {
  static final CinemaDao _singleton = CinemaDao.internal();

  factory CinemaDao() {
    return _singleton;
  }

  CinemaDao.internal();

  void saveCinemas(List<CinemaVO> cinemaList, String date) async {
    List<CinemaVO> updatedCinemaList = cinemaList.map((cinema) {
      CinemaVO cinemaFromHive = this.getCinemaById(cinema.cinemaId);
      if (cinemaFromHive == null) {
        return cinema;
      } else {
        cinemaFromHive.dates = {};
        cinemaFromHive.dates.add(date);
        return cinemaFromHive;
      }
    }).toList();

    Map<int, CinemaVO> cinemaMap = Map.fromIterable(
      updatedCinemaList,
      key: (cinema) => cinema.cinemaId,
      value: (cinema) => cinema,
    );

    await getCinemaBox().putAll(cinemaMap);
  }

  CinemaVO getCinemaById(int cinemaId) {
    return getCinemaBox().get(cinemaId);
  }

  Box<CinemaVO> getCinemaBox() {
    return Hive.box<CinemaVO>(BOX_NAME_CINEMA_VO);
  }

  Stream<void> getCinemaEventStream() {
    return getCinemaBox().watch();
  }

  Stream<List<CinemaVO>> getCinemasByDateStream(String date) {
    List<CinemaVO> allCinemas = getCinemaBox().values.toList();
    return Stream.value(allCinemas.where((cinema) => cinema.dates.contains(date)).toList());
  }
}
