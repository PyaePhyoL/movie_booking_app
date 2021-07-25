import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

part 'snack_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_SNACK_VO, adapterName: "SnackVOAdapter")
class SnackVO{
  @JsonKey(name: "id")
  @HiveField(0)
  int id;

  @JsonKey(name: "name")
  @HiveField(1)
  String name;

  @JsonKey(name: "description")
  @HiveField(2)
  String description;

  @JsonKey(name: "price")
  @HiveField(3)
  double price;

  @JsonKey(name: "image")
  @HiveField(4)
  String image;

  @JsonKey(name: "quantity")
  @HiveField(5)
  int qty;

  @JsonKey(name: "total_amount")
  @HiveField(6)
  double totalAmount;

  SnackVO(this.id, this.name, this.description, this.price, this.image, this.qty);


  @override
  String toString() {
    return 'SnackVO{id: $id, name: $name, description: $description, price: $price, image: $image, qty: $qty, totalAmount: $totalAmount}';
  }

  factory SnackVO.fromJson(Map<String, dynamic> json) => _$SnackVOFromJson(json);

  Map<String, dynamic> toJson() => _$SnackVOToJson(this);

}