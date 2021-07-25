import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';

abstract class AuthModel{
  FacebookLogin facebookUser = FacebookLogin();
  GoogleSignIn googleUser = GoogleSignIn();

  Future<UserVO> postLoginWithEmail(String email, String password);

  Future<UserVO> postRegisterWithEmail(
      String name,
      String email,
      String password,
      String phone,
  {String fbAccessToken, String googleAccessToken,}
      );

  Future<String> postLogout(String token);

  Future<UserVO> getUserFromDatabase();
  Future<String> getTokenFromDatabase();
  void deleteTokenFromDatabase();
  void deleteUserFromDatabase();
  Future<UserVO> postLoginWithFacebook(String token);
  Future<UserVO> postLoginWithGoogle(String token);

}