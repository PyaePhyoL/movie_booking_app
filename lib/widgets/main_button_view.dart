import 'package:flutter/material.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class MainButtonView extends StatelessWidget {
  final String title;
  final bool isGhostButton;
  final Function onTapButton;

  MainButtonView(
    this.title,
    this.onTapButton, {
    this.isGhostButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapButton();
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
          border: (isGhostButton)
              ? Border.all(
                  color: Colors.white,
                  width: 1,
                )
              : null,
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
