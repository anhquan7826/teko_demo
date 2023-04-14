import 'package:json_annotation/json_annotation.dart';

part 'product.model.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class Product {
  Product({
    this.id = -1,
    this.name = '',
    this.sku = '',
    this.image = '',
    this.errorDescription = '',
    this.color = -1,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  final int id;
  final String image;
  final String errorDescription;
  final String name;
  final String sku;
  final int color;

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? name,
    String? sku,
    int? color,
  }) {
    return Product(
      id: id,
      image: image,
      errorDescription: errorDescription,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      color: color ?? this.color,
    );
  }
}
