import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:movie_booking_app/data/models/auth_model.dart';
import 'package:movie_booking_app/data/models/auth_model.impl.dart';
import 'package:movie_booking_app/pages/home_page.dart';
import 'package:movie_booking_app/persistence/daos/profile_dao.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/utility_functions.dart';
import 'package:movie_booking_app/widgets/label_title.dart';
import 'package:movie_booking_app/widgets/login_confirm_button.dart';
import 'package:movie_booking_app/widgets/register_confirm_button.dart';
import 'package:movie_booking_app/widgets/title_text.dart';
import 'package:movie_booking_app/network/responses/facebook_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class LoginRegisterPage extends StatefulWidget {
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  AuthModel authModel = AuthModelImpl();

  String fbAccessToken;
  String googleAccessToken;
  String profilePicture;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ProfileDao mProfileDao = ProfileDao();

  @override
  void initState() {
    super.initState();

    authModel.googleUser.disconnect();
    authModel.facebookUser.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: LOGIN_SCREEN_TOP_MARGIN,
            left: MARGIN_MEDIUM_2,
            right: MARGIN_MEDIUM_2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeTitleSection(),
              SizedBox(
                height: MARGIN_XLARGE,
              ),
              LoginAndRegisterSection(
                (email, password) =>
                    _loginAndNavigateToHomeScreen(context, email, password),
                (name, email, password, phone) =>
                    _registerAndNavigateToHomeScreen(
                        context, name, email, password, phone),
                facebookLogin: () => _loginWithFacebook(context),
                facebookRegister: () => _registerWithFacebook(),
                googleRegister: () => _registerWithGoogle(),
                googleSignIn: () => _loginWithGoogle(),
                nameController: nameController,
                emailController: emailController,
                passwordController: passwordController,
                phoneController: phoneController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginAndNavigateToHomeScreen(
      BuildContext context, String email, String password) {
    authModel.postLoginWithEmail(email, password).then((user) {
      debugPrint("User VO ===> ${user.toString()}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage();
        }),
      );
    }).catchError((error) => handleError(context, error));
  }

  void _registerAndNavigateToHomeScreen(BuildContext context, String name,
      String email, String password, String phone) {
    authModel
        .postRegisterWithEmail(
      name,
      email,
      password,
      phone,
      fbAccessToken: fbAccessToken,
      googleAccessToken: googleAccessToken,
    )
        .then((user) {
      debugPrint("Result ===> ${user.toString()}");

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }).catchError((error) => handleError(context, error));
  }

  Future _registerWithFacebook() async {
    FacebookLoginResult result = await authModel.facebookUser.logIn(['email']);

    final graphResponse = await http.get(
      Uri.https(
        "graph.facebook.com",
        "/v2.12/me",
        {
          "fields": "name, picture, email",
          "access_token": "${result.accessToken.token}",
        },
      ),
    );

    final profile = JSON.jsonDecode(graphResponse.body);

    FacebookResponse fbProfile = FacebookResponse.fromJson(profile);

    mProfileDao.saveProfile(fbProfile.picture.data.photoUrl);

    if (result.status == FacebookLoginStatus.loggedIn) {
      setState(() {
        this.fbAccessToken = fbProfile.id;
        this.profilePicture = fbProfile.picture.data.photoUrl;
        nameController.text = fbProfile.name;
        emailController.text = fbProfile.email;
      });
    }
  }

  Future _loginWithFacebook(BuildContext context) async {
    FacebookLoginResult result = await authModel.facebookUser.logIn(['email']);

    final graphResponse =
        await http.get(Uri.https("graph.facebook.com", "/v2.12/me", {
      "fields": "name, picture, email",
      "access_token": "${result.accessToken.token}",
    }));

    final profile = JSON.jsonDecode(graphResponse.body);

    FacebookResponse fbProfile = FacebookResponse.fromJson(profile);

    mProfileDao.saveProfile(fbProfile.picture.data.photoUrl);

    if (result.status == FacebookLoginStatus.loggedIn) {
      String token = fbProfile.id;

      authModel.postLoginWithFacebook(token).then((user) async {
        debugPrint("Fb User ==> ${user.toString()}");

        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
      });
    }
  }

  Future _loginWithGoogle() async {
    authModel.googleUser.signIn().then((user) {
      user.authentication.then((auth) {
        String token = user.id;

        debugPrint("Google Token ===> $token");

        authModel.postLoginWithGoogle(token).then((user) {
          debugPrint("Google User ===> ${user.toString()}");

          authModel
              .getUserFromDatabase()
              .then((user) => debugPrint(" \$User ==> ${user.toString()}"));

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        });
      });
    });
  }

  Future _registerWithGoogle() async {
    authModel.googleUser.signIn().then((user) {
      debugPrint("User id ===> ${user.id}");

      user.authentication.then((auth) {
        setState(() {
          googleAccessToken = user.id;
          nameController.text = user.displayName;
          emailController.text = user.email;
        });
      });
    });
  }
}

class LoginAndRegisterSection extends StatelessWidget {
  final Function(String, String) loginFunc;
  final Function(String, String, String, String) registerFunc;
  final Function facebookLogin;
  final Function facebookRegister;
  final Function googleRegister;
  final Function googleSignIn;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;

  LoginAndRegisterSection(
    this.loginFunc,
    this.registerFunc, {
    this.facebookLogin,
    this.facebookRegister,
    this.googleRegister,
    this.googleSignIn,
    this.emailController,
    this.nameController,
    this.phoneController,
    this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: PRIMARY_COLOR,
            labelStyle: TextStyle(
              fontSize: TEXT_REGULAR_2X,
              fontWeight: FontWeight.w500,
            ),
            indicatorColor: PRIMARY_COLOR,
            unselectedLabelColor: Colors.black,
            indicatorWeight: 4,
            tabs: [
              Tab(child: Text(LOGIN_TITLE)),
              Tab(child: Text(REGISTER_TITLE)),
            ],
          ),
          Container(
            height: 620,
            child: TabBarView(
              children: [
                LoginTabBarView(
                  (email, password) => loginFunc(email, password),
                  fbLoginFunc: () => facebookLogin(),
                  ggLoginFunc: () => googleSignIn(),
                ),
                RegisterTabBarView(
                  (name, email, password, phone) =>
                      registerFunc(name, email, password, phone),
                  () => facebookRegister(),
                  () => googleRegister(),
                  nameController: nameController,
                  emailController: emailController,
                  passwordController: passwordController,
                  phoneController: phoneController,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MARGIN_XLARGE,
          ),
        ],
      ),
    );
  }
}

class LoginTabBarView extends StatelessWidget {
  final Function(String, String) navigateFunc;
  final Function fbLoginFunc;
  final Function ggLoginFunc;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginTabBarView(this.navigateFunc, {this.fbLoginFunc, this.ggLoginFunc});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
          ),
          EmailAndPasswordSection(emailController, passwordController),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          ForgotPasswordButtonView(),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          SocialMediaLoginButtonView(
            titleText: SIGN_IN_WITH_FACEBOOK_TITLE,
            imageUrl: "assets/images/facebook.png",
            socialMediaLogin: () => fbLoginFunc(),
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          SocialMediaLoginButtonView(
            titleText: SIGN_IN_WITH_GOOGLE_TITLE,
            imageUrl: "assets/images/google.png",
            socialMediaLogin: () => ggLoginFunc(),
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          LoginConfirmButton(
            CONFIRM_TITLE,
            (email, password) {
              navigateFunc(email, password);
              print("Tapped Login Button");
            },
            emailController,
            passwordController,
          ),
        ],
      ),
    );
  }
}

class RegisterTabBarView extends StatelessWidget {
  final Function(String, String, String, String) registerFunc;
  final Function facebookRegister;
  final Function googleRegister;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;

  RegisterTabBarView(
    this.registerFunc,
    this.facebookRegister,
    this.googleRegister, {
    this.nameController,
    this.emailController,
    this.passwordController,
    this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MARGIN_LARGE,
          ),
          LabelTitle(NAME_TITLE),
          GeneralTextFieldView(nameController),
          SizedBox(
            height: MARGIN_LARGE,
          ),
          EmailAndPasswordSection(emailController, passwordController),
          SizedBox(
            height: MARGIN_LARGE,
          ),
          LabelTitle(PHONE_NUMBER_TITLE),
          GeneralTextFieldView(phoneController),
          SizedBox(
            height: MARGIN_LARGE,
          ),
          SocialMediaLoginButtonView(
            titleText: REGISTER_WITH_FACEBOOK_TITLE,
            imageUrl: "assets/images/facebook.png",
            socialMediaLogin: () => facebookRegister(),
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          SocialMediaLoginButtonView(
            titleText: REGISTER_WITH_GOOGLE_TITLE,
            imageUrl: "assets/images/google.png",
            socialMediaLogin: () => googleRegister(),
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          RegisterConfirmButton(
            CONFIRM_TITLE,
            (name, email, password, phone) =>
                registerFunc(name, email, password, phone),
            nameController,
            emailController,
            passwordController,
            phoneController,
          ),
        ],
      ),
    );
  }
}

class EmailAndPasswordSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  EmailAndPasswordSection(this.emailController, this.passwordController);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTitle(EMAIL_TITLE),
        GeneralTextFieldView(emailController),
        SizedBox(
          height: MARGIN_LARGE,
        ),
        LabelTitle(PASSWORD_TITLE),
        GeneralTextFieldView(
          passwordController,
          isPasswordField: true,
        ),
      ],
    );
  }
}

class ForgotPasswordButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {},
          child: LabelTitle(FORGOT_PASSWORD_TITLE),
        ),
      ],
    );
  }
}

class SocialMediaLoginButtonView extends StatelessWidget {
  final String imageUrl;
  final String titleText;
  final Function socialMediaLogin;

  SocialMediaLoginButtonView({
    @required this.titleText,
    @required this.imageUrl,
    this.socialMediaLogin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => socialMediaLogin(),
      child: Container(
        width: MAIN_BUTTON_WIDTH,
        height: MAIN_BUTTON_HEIGHT,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: SECONDARY_TEXT_COLOR, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MARGIN_XXLARGE,
            ),
            Container(
              width: 28,
              height: 28,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: MARGIN_XLARGE,
            ),
            Text(
              titleText,
              style: TextStyle(
                color: SOCIAL_LOGIN_TEXT_COLOR,
                fontSize: TEXT_MEDIUM,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GeneralTextFieldView extends StatelessWidget {
  final bool isPasswordField;

  final TextEditingController textController;

  GeneralTextFieldView(this.textController, {this.isPasswordField = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      cursorHeight: MARGIN_LARGE,
      obscureText: isPasswordField,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: MARGIN_MEDIUM),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: SECONDARY_TEXT_COLOR),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: SECONDARY_TEXT_COLOR),
        ),
      ),
      cursorColor: PRIMARY_COLOR,
    );
  }
}

class WelcomeTitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(WELCOME_TITLE),
        SizedBox(
          height: MARGIN_MEDIUM,
        ),
        LabelTitle(WELCOME_BACK_LOGIN_TO_CONTINUE_TITLE),
      ],
    );
  }
}
