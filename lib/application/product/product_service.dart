import 'package:hiring_test/domain/product_color/product_color.model.dart';
import 'package:hiring_test/repository/product_color/product_color.repository.dart';

import '../../domain/product/product.model.dart';
import '../../repository/product/product.repository.dart';

class ProductService {
  ProductService._();

  static final _productRepository = ProductRepository();
  static final _productColorRepository = ProductColorRepository();

  static final Map<int, Product> _products = {};
  static final Map<int, ProductColor> _colors = {};

  static final Map<int, Product> _pendingChanges = {};

  static Future<void> loadData() async {
    _pendingChanges.clear();
    _products
      ..clear()
      ..addEntries((await _productRepository.getAllProducts()).map((e) {
        return MapEntry(e.id, e);
      }));
    _colors
      ..clear()
      ..addAll(await _productColorRepository.getAllColors());
  }

  static List<Product> getAllProducts() {
    return _products.values.toList();
  }

  static List<int> getAllProductIds() {
    return _products.keys.toList();
  }

  static Product? getProduct({required int id}) {
    return _products[id];
  }

  static Product? getProductChanges({required int id}) {
    return _pendingChanges[id];
  }

  static void setProductChanges({required Product product}) {
    _pendingChanges[product.id] = product;
  }

  static bool hasChanges() {
    return _pendingChanges.isNotEmpty;
  }

  static void discardChanges() {
    _pendingChanges.clear();
  }

  static void applyChanges() {
    for (final change in _pendingChanges.entries) {
      _products[change.key] = change.value;
    }
    _pendingChanges.clear();
  }

  static ProductColor? getColor({required int id}) {
    return _colors[id];
  }
}