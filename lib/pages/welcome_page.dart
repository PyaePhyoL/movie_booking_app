import 'package:flutter/material.dart';
import 'package:movie_booking_app/pages/login_register_page.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/main_button_view.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: PRIMARY_COLOR,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            WelcomeImageSection(),
            SizedBox(
              height: MARGIN_XLARGE,
            ),
            WelcomeTitleSection(),
          ],
        ),
      ),
      floatingActionButton: MainButtonView(
        GET_STARTED_TITLE,
        () => _navigateToLoginRegisterScreen(context),
        isGhostButton: true,
      ),
    );
  }

  Future _navigateToLoginRegisterScreen(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginRegisterPage();
        },
      ),
    );
  }
}

class WelcomeImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: WELCOME_SCREEN_ICON_WIDTH,
      height: WELCOME_SCREEN_ICON_HEIGHT,
      child: Image.asset(
        "assets/images/movie_booking_logo.png",
        fit: BoxFit.cover,
      ),
    );
  }
}

class WelcomeTitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          WELCOME_TITLE,
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_HEADING_2X,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          HELLO_WELCOME_TO_GALAXY_APP_TITLE,
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
      ],
    );
  }
}
