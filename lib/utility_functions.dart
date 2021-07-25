import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/network/responses/error_response.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class UtilityFunctions {
  static String coverCreditCardNumber(String cardNumber) {
    List<String> numList = cardNumber.split(" ");
    List<String> coverNumList = [];

    for (int i = 0; i < numList.length; i++) {
      String num = numList[i];

      if (i != numList.length - 1) {
        String replaceNum = num.replaceAll(num, "****");
        coverNumList.add(replaceNum);
      } else {
        coverNumList.add(num);
      }
    }

    return coverNumList.join(" ");
  }

  static String formatDate(String date) {
    List<String> dateList = date.split("/");

    List<String> newDateList = [dateList[2], dateList[0], dateList[1]];

    String format = newDateList.join("-");

    return format;
  }
}

void handleError(BuildContext context, dynamic error) {
  if (error is DioError) {
    try {
      debugPrint("Error Code===>  ${error.response.statusCode}");

      debugPrint("error ===> ${error.response}");
      ErrorResponse errorResponse = ErrorResponse.fromJson(error.response.data);

      showErrorDialog(context, errorResponse.message);
    } on Error catch (e) {
      showErrorDialog(context, error.toString());
    }
  } else {
    showErrorDialog(context, error);
  }
}

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Something Went Wrong"),

      content: Text(errorMessage, style: TextStyle(fontSize: TEXT_REGULAR_3X),),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("OK"),
        ),
      ],
    ),
  );
}
