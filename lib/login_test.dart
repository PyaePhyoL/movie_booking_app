// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//
// class LoginTest extends StatefulWidget {
//   @override
//   _LoginTestState createState() => _LoginTestState();
// }
//
// class _LoginTestState extends State<LoginTest> {
//
//   FacebookLogin facebookLogin = FacebookLogin();
//
//   Future loginWithFb() async {
//     FacebookLoginResult result = await facebookLogin.logIn(['email']);
//
//     switch(result.status){
//       case FacebookLoginStatus.loggedIn:
//         FacebookAccessToken accessToken = result.accessToken;
//         print("Login in ===> ${accessToken.token} , ${accessToken.userId}");
//         break;
//       case FacebookLoginStatus.cancelledByUser:
//         print("Cancelled by User");
//         break;
//       case FacebookLoginStatus.error:
//         print("Error ===> ${result.errorMessage}");
//         break;
//     }
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Facebook Login"),),
//       body: Container(
//         child: Center(
//           child: ElevatedButton(
//             child: Text("Login with facebook"),
//             onPressed: () => loginWithFb(),
//           ),
//         ),
//       ),
//     );
//   }
// }
