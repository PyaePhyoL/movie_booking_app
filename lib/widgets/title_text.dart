import 'package:flutter/material.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class TitleText extends StatelessWidget {
  final String title;

  TitleText(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: TEXT_HEADING_2X,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
