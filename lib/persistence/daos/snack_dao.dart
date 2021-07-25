import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

class SnackDao {
  static final SnackDao _singleton = SnackDao.internal();

  factory SnackDao() {
    return _singleton;
  }

  SnackDao.internal();

  void saveSnacks(List<SnackVO> snackList) async{
    Map<int, SnackVO> snackMap = Map.fromIterable(
      snackList,
      key: (snack) => snack.id,
      value: (snack) => snack,
    );

    await getSnackBox().putAll(snackMap);
  }

  List<SnackVO> getAllSnacks() {
    return getSnackBox().values.toList();
  }

  Box<SnackVO> getSnackBox() {
    return Hive.box<SnackVO>(BOX_NAME_SNACK_VO);
  }

  /// Reactive
  Stream<void> getAllSnacksEventStream() {
    return getSnackBox().watch();
  }

  Stream<List<SnackVO>> getAllSnacksStream() {
    return Stream.value(getAllSnacks());
  }
}
