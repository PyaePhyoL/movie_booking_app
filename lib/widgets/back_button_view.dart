import 'package:flutter/material.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class BackButtonView extends StatelessWidget {
  final Function onTapBack;

  BackButtonView(this.onTapBack);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBack,
      child: Icon(
        Icons.chevron_left,
        size: ICON_MEDIUM_2,
        color: Colors.black,
      ),
    );
  }
}