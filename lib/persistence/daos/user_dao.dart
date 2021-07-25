import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

class UserDao{
  static final UserDao _singleton = UserDao._internal();

  factory UserDao() {
    return _singleton;
  }

  UserDao._internal();

  void saveUser(UserVO user) async{
    await getUserBox().add(user);
  }

  UserVO getUser(){
    return getUserBox().values.last;
  }

  void deleteUser() async{
    await getUserBox().clear();
  }

  Box<UserVO> getUserBox() {
    return Hive.box<UserVO>(BOX_NAME_USER_VO);
  }

  /// Reactive
  Stream<void> getUserEventStream() {
    return getUserBox().watch();
  }

  Stream<UserVO> getUserStream() {
    return Stream.value(getUser());
  }

}