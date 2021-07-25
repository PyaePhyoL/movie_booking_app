import 'package:flutter/material.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class RegisterConfirmButton extends StatelessWidget {
  final String title;
  final Function(String, String, String, String) onTapButton;

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;

  RegisterConfirmButton(
    this.title,
    this.onTapButton,
    this.nameController,
    this.emailController,
    this.passwordController,
    this.phoneNumberController,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapButton(nameController.text, emailController.text, passwordController.text, phoneNumberController.text);
      },
      child: Container(
        width: MAIN_BUTTON_WIDTH,
        height: MAIN_BUTTON_HEIGHT,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: PRIMARY_SHADOW_COLOR,
              offset: Offset(0, 5),
              blurRadius: 6,
              spreadRadius: 3,
            ),
          ],
          borderRadius: BorderRadius.circular(8),
          color: PRIMARY_COLOR,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
