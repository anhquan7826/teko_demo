import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiring_test/application/product/product.state.dart';

import '../../domain/product/product.model.dart';
import '../../domain/product_color/product_color.model.dart';
import '../../repository/product/product.repository.dart';
import '../../repository/product_color/product_color.repository.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductInitialState()) {
    loadData();
  }

  final _productRepository = ProductRepository();
  final _productColorRepository = ProductColorRepository();

  final Map<int, Product> _products = {};
  final Map<int, ProductColor> _colors = {};

  final Map<int, Product> _pendingChanges = {};

  Future<void> loadData() async {
    try {
      emit(const ProductLoadingState());
      _pendingChanges.clear();
      _products
        ..clear()
        ..addEntries((await _productRepository.getAllProducts()).map((e) {
          return MapEntry(e.id, e);
        }));
      _colors
        ..clear()
        ..addAll(await _productColorRepository.getAllColors())
        ..[-1] = ProductColor.noColor();
      emit(const ProductLoadedState());
    } catch (_) {
      emit(const ProductLoadErrorState());
    }
  }

  List<Product> getAllProducts() {
    return _products.values.toList();
  }

  List<int> getAllProductIds() {
    return _products.keys.toList();
  }

  Product? getProduct({required int id}) {
    return _products[id];
  }

  List<int> getAllChangesIds() {
    return _pendingChanges.keys.toList();
  }

  Map<Product, Product> getAllChanges() {
    return Map.fromEntries(_pendingChanges.keys.map((id) {
      return MapEntry(_products[id]!, _pendingChanges[id]!);
    }));
  }

  Product? getProductChanges({required int id}) {
    return _pendingChanges[id];
  }

  void setProductChanges({required Product product}) {
    _pendingChanges[product.id] = product;
    emit(ProductChangedState(product));
  }

  bool hasChanges() {
    return _pendingChanges.isNotEmpty;
  }

  void discardChanges({int? id}) {
    if (id == null) {
      _pendingChanges.clear();
    } else {
      _pendingChanges.remove(id);
    }
    emit(ProductDiscardedState(id));
  }

  void applyChanges() {
    for (final change in _pendingChanges.entries) {
      _products[change.key] = change.value;
    }
    _pendingChanges.clear();
    emit(const ProductAppliedState());
  }

  ProductColor? getColor({required int id}) {
    return _colors[id];
  }

  List<ProductColor> getAllColors() {
    return _colors.values.toList();
  }
}
