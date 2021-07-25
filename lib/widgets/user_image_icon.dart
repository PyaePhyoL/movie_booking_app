import 'package:flutter/material.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class UserImageIcon extends StatelessWidget {
  final String imageUrl;
  final double iconSize;

  UserImageIcon(
    this.imageUrl, {
    this.iconSize = CIRCLE_AVATAR_ICON_SIZE,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: iconSize,
      width: iconSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(iconSize / 2),
        child: Image.network(
          "$IMAGE_BASE_URL$imageUrl",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
