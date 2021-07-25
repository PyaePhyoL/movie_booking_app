import 'package:movie_booking_app/data/models/auth_model.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/network/dataagents/movie_cinema_data_agent.dart';
import 'package:movie_booking_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:movie_booking_app/persistence/daos/token_dao.dart';
import 'package:movie_booking_app/persistence/daos/user_dao.dart';

class AuthModelImpl extends AuthModel {
  static final AuthModelImpl _singleton = AuthModelImpl._internal();

  factory AuthModelImpl() {
    return _singleton;
  }

  AuthModelImpl._internal();

  MovieCinemaDataAgent mDataAgent = RetrofitDataAgentImpl();

  UserDao mUserDao = UserDao();
  TokenDao mTokenDao = TokenDao();

  @override
  Future<UserVO> postLoginWithEmail(String email, String password) {
     return mDataAgent.postLoginWithEmail(email, password).then((user) async {
      mUserDao.saveUser(user);

      // save token to database
      mTokenDao.saveToken(mDataAgent.token);
      return Future.value(user);
     });
  }

  @override
  Future<String> postLogout(String token) {
    deleteUserFromDatabase();
    deleteTokenFromDatabase();

    return mDataAgent.postLogout(token);
  }

  @override
  Future<UserVO> postRegisterWithEmail(
      String name, String email, String password, String phone,
      {String fbAccessToken, String googleAccessToken}) {
    return mDataAgent
        .postRegisterWithEmail(name, email, password, phone,
            fbAccessToken: fbAccessToken, googleAccessToken: googleAccessToken)
        .then((user) async {
      mUserDao.saveUser(user);
      mTokenDao.saveToken(mDataAgent.token);

      return Future.value(user);
    });
  }

  @override
  Future<UserVO> postLoginWithFacebook(String token) {
    return mDataAgent.postLoginWithFacebook(token).then((user) async {
      mUserDao.saveUser(user);
      mTokenDao.saveToken(mDataAgent.token);

      return Future.value(user);
    });
  }

  @override
  Future<UserVO> postLoginWithGoogle(String token) {
    return mDataAgent.postLoginWithGoogle(token).then((user) async {
      mUserDao.saveUser(user);
      mTokenDao.saveToken(mDataAgent.token);

      return Future.value(user);
    });
  }

  @override
  Future<UserVO> getUserFromDatabase() {
    return Future.value(mUserDao.getUser());
  }

  @override
  Future<String> getTokenFromDatabase() {
    return Future.value(mTokenDao.getToken());
  }

  @override
  void deleteUserFromDatabase() {
    mUserDao.deleteUser();
  }

  @override
  void deleteTokenFromDatabase() {
    mTokenDao.deleteToken();
  }
}
