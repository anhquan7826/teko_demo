import 'dart:io';

import 'package:hiring_test/helper/exception/network_exception.dart';
import 'package:hiring_test/repository/repository.dart';

import '../../domain/product_color/product_color.model.dart';

class ProductColorRepository extends Repository {
  Future<Map<int, ProductColor>> getAllColors() async {
    final response = await dio.get<List<dynamic>>('https://hiring-test.stag.tekoapis.net/api/colors');
    if (response.statusCode == HttpStatus.ok) {
      return Map.fromEntries((response.data ?? []).map((e) {
        final color = ProductColor.fromJson((e as Map).cast<String, dynamic>());
        return MapEntry(color.id, color);
      }));
    } else {
      throw NetworkException(response.statusMessage);
    }
  }
}