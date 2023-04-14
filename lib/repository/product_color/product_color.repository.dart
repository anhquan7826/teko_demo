import 'dart:io';

import 'package:hiring_test/helper/exception/network_exception.dart';
import 'package:hiring_test/repository/repository.dart';

import '../../domain/product_color/product_color.model.dart';

class ProductColorRepository extends Repository {
  Future<Map<int, ProductColor>> getAllColors() async {
    final response = await dio.get<List<dynamic>>('https://hiring-test.stag.tekoapis.net/api/colors');
    if (response.statusCode == HttpStatus.ok) {
      return Map.fromEntries((response.data?.asMap() ?? {}).entries.map((e) {
        return MapEntry(e.key, ProductColor.fromJson((e.value as Map).cast<String, dynamic>()));
      }));
    } else {
      throw NetworkException(response.statusMessage);
    }
  }
}