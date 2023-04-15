import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiring_test/application/product/product.service.dart';
import 'package:hiring_test/presentation/product/product.state.dart';

import '../../domain/product/product.model.dart';

class ProductCubit extends Cubit<ProductEditingState> {
  ProductCubit(this.context, this.id) : super(const ProductEditingInitialState()) {
    if (original == null) {
      emit(const ProductEditNotFoundState());
    } else {
      _name = (changed ?? original!).name;
      _sku = (changed ?? original!).sku;
      _color = (changed ?? original!).color;
    }
  }

  final BuildContext context;
  final int id;

  Product? get original => BlocProvider.of<ProductService>(context).getProduct(id: id);
  Product? get changed => BlocProvider.of<ProductService>(context).getProductChanges(id: id);

  late String _name;
  late String _sku;
  late int _color;

  String get name => _name;
  String get sku => _sku;
  int get color => _color;

  bool hasChanges() {
    return _name != (changed ?? original!).name || _sku != (changed ?? original!).sku || _color != (changed ?? original!).color;
  }

  bool get highlightName => _name != original!.name;

  bool get highlightSKU => _sku != original!.sku;

  bool get highlightColor => _color != original!.color;

  void setValue({String? name, String? sku, int? color}) {
    _name = name ?? _name;
    _sku = sku ?? _sku;
    _color = color ?? _color;
    emit(ProductEditChangedState(color: _color, name: _name, sku: _sku,));
  }

  bool isInvalid() {
    if (_name.isEmpty || _name.length > 50) {
      return true;
    }
    if (_sku.isEmpty || _sku.length > 20) {
      return true;
    }
    return false;
  }

  void save() {
    BlocProvider.of<ProductService>(context).setProductChanges(product: original!.copyWith(name: _name, sku: _sku, color: _color,),);
  }

  void revert() {
    BlocProvider.of<ProductService>(context).discardChanges(id: id);
    _name = original!.name;
    _sku = original!.sku;
    _color = original!.color;
    emit(const ProductEditRevertedState());
  }
}
