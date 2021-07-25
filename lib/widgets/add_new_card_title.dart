import 'package:flutter/material.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';

class AddNewCardTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.add_circle_outlined,
          color: SUB_TOTAL_TITLE_COLOR,
          size: ICON_MEDIUM,
        ),
        SizedBox(
          width: MARGIN_MEDIUM,
        ),
        Text(
          ADD_NEW_CARD_TITLE,
          style: TextStyle(
              fontSize: TEXT_MEDIUM,
              fontWeight: FontWeight.w600,
              color: SUB_TOTAL_TITLE_COLOR),
        ),
      ],
    );
  }
}
