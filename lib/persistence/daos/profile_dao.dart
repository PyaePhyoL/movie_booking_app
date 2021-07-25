import 'package:hive/hive.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

class ProfileDao{
  static final ProfileDao _singleton = ProfileDao.internal();

  factory ProfileDao(){
    return _singleton;
  }

  ProfileDao.internal();

  void saveProfile(String photoUrl) async{
    await getProfileBox().put("profile", photoUrl);
  }

  String getProfile(){
    return getProfileBox().get("profile");
  }

  void deleteProfile()async{
    await getProfileBox().clear();
  }

  Box getProfileBox() {
    return Hive.box(BOX_NAME_PROFILE);
  }
}