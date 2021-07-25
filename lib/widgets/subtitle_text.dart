import 'package:flutter/material.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class SubtitleText extends StatelessWidget {
  final String titleText;

  SubtitleText(this.titleText);

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: TextStyle(
        fontSize: TEXT_LARGE,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}