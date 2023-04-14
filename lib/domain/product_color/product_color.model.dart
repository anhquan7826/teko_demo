import 'package:json_annotation/json_annotation.dart';

part 'product_color.model.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class ProductColor {
  const ProductColor({this.id = -1, this.name = ''});

  factory ProductColor.fromJson(Map<String, dynamic> json) =>
      _$ProductColorFromJson(json);

  final int id;
  final String name;

  Map<String, dynamic> toJson() => _$ProductColorToJson(this);
}
