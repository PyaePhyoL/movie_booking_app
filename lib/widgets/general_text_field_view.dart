import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class GeneralTextFieldView extends StatelessWidget {
  final bool isPasswordField;
  final TextEditingController textController;

  GeneralTextFieldView(this.textController, {this.isPasswordField = false,});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorHeight: MARGIN_LARGE,
      obscureText: isPasswordField,
      controller: textController,
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