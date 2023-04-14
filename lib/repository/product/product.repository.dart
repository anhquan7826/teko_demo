import 'dart:io';

import 'package:hiring_test/helper/exception/network_exception.dart';
import 'package:hiring_test/repository/repository.dart';

import '../../domain/product/product.model.dart';

class ProductRepository extends Repository {
  Future<List<Product>> getAllProducts() async {
    final response = await dio.get<List<dynamic>>('https://hiring-test.stag.tekoapis.net/api/products');
    if (response.statusCode == HttpStatus.ok) {
      return response.data?.map((e) {
        return Product.fromJson((e as Map).cast<String, dynamic>());
      }).toList() ?? [];
    } else {
      throw NetworkException(response.statusMessage);
    }
  }
}