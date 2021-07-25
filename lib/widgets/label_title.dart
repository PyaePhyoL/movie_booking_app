import 'package:flutter/material.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class LabelTitle extends StatelessWidget {
  final String title;

  LabelTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: SECONDARY_TEXT_COLOR,
        fontSize: 15,
      ),
    );
  }
}
