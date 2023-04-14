// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int? ?? -1,
      name: json['name'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      image: json['image'] as String? ?? '',
      errorDescription: json['errorDescription'] as String? ?? '',
      color: json['color'] as int?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'image': instance.image,
      'errorDescription': instance.errorDescription,
      'color': instance.color,
    };
