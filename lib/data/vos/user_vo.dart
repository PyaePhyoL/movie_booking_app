import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

part 'user_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_USER_VO, adapterName: "UserVOAdapter")
class UserVO {
  @JsonKey(name: "id")
  @HiveField(0)
  int id;

  @JsonKey(name: "name")
  @HiveField(1)
  String name;

  @JsonKey(name: "email")
  @HiveField(2)
  String email;

  @JsonKey(name: "phone")
  @HiveField(3)
  String phone;

  @JsonKey(name: "total_expense")
  @HiveField(4)
  double totalExpense;

  @JsonKey(name: "profile_image")
  @HiveField(5)
  String profileImage;

  @JsonKey(name: "cards")
  @HiveField(6)
  List<CardVO> cards;

  UserVO(
      this.id,
      this.name,
      this.email,
      this.phone,
      this.totalExpense,
      this.profileImage,
      this.cards,
      );

  @override
  String toString() {
    return 'UserVO{id: $id, name: $name, email: $email, phone: $phone, totalExpense: $totalExpense, profileImage: $profileImage, cards: $cards}';
  }

  factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);

  Map<String, dynamic> toJson() => _$UserVOToJson(this);
}
