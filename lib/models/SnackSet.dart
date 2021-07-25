import 'package:flutter/foundation.dart';

class SnackSet {
  int id;
  String name;
  String info;
  int singleSetPrice;
  int totalPrice = 0;
  int qty = 0;

  SnackSet({
    @required this.id,
    @required this.name,
    @required this.info,
    @required this.singleSetPrice,
  });
}
