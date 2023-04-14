import 'dart:io';

import 'package:hiring_test/helper/exception/network_exception.dart';
import 'package:hiring_test/repository/repository.dart';

import '../../domain/product_color/product_color.model.dart';

class ProductColorRepository extends Repository {
  Future<List<ProductColor>> getAllColors() async {
    final response = await dio.get<List<Map<String, dynamic>>>('https://hiring-test.stag.tekoapis.net/api/colors');
    if (response.statusCode == HttpStatus.ok) {
      return response.data?.map((e) {
        return ProductColor.fromJson(e);
      }).toList() ?? [];
    } else {
      throw NetworkException(response.statusMessage);
    }
  }

  Future<ProductColor> getColor({required int id}) async {
    try {
      final colors = await getAllColors();
      return colors.firstWhere((color) => color.id == id);
    } on NetworkException catch (_) {
      rethrow;
    }
  }
}