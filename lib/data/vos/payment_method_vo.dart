import 'package:json_annotation/json_annotation.dart';

part 'payment_method_vo.g.dart';

@JsonSerializable()
class PaymentMethodVO{
  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "description")
  String description;

  PaymentMethodVO(this.id, this.name, this.description);

  @override
  String toString() {
    return 'PaymentMethodVO{id: $id, name: $name, description: $description}';
  }

  factory PaymentMethodVO.fromJson(Map<String, dynamic> json) => _$PaymentMethodVOFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodVOToJson(this);
}