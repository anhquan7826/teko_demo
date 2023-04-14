import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiring_test/application/product/product.cubit.dart';

import '../../domain/product/product.model.dart';
import '../../domain/product_color/product_color.model.dart';
import 'edit.state.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit(this.context, this.id) : super(const EditInitialState()) {
    final original = BlocProvider.of<ProductCubit>(context).getProduct(id: id);
    final changed = BlocProvider.of<ProductCubit>(context).getProductChanges(id: id);
    if (original == null) {
      emit(const EditProductNotFoundState());
    } else {
      _originalProduct = original;
      product = changed ?? original;
      nameController = TextEditingController(text: product.name);
      skuController = TextEditingController(text: product.sku);
      color = BlocProvider.of<ProductCubit>(context).getColor(id: product.color) ?? ProductColor.noColor();
    }
  }

  final BuildContext context;
  final int id;

  late final Product _originalProduct;
  late final Product product;

  late final TextEditingController nameController;
  late final TextEditingController skuController;
  late ProductColor color;

  void onChanged() {
    emit(EditChangedState(
      color: color.id,
      name: nameController.text,
      sku: skuController.text,
    ));
  }

  bool hasChanges() {
    return nameController.text != _originalProduct.name || skuController.text != _originalProduct.sku || color.id != _originalProduct.color;
  }

  bool isInvalid() {
    if (nameController.text.isEmpty || nameController.text.length > 50) {
      return true;
    }
    if (skuController.text.isEmpty || skuController.text.length > 20) {
      return true;
    }
    return false;
  }

  void save() {
    BlocProvider.of<ProductCubit>(context).setProductChanges(
      product: product.copyWith(
        name: nameController.text,
        sku: skuController.text,
        color: color.id,
      ),
    );
  }

  void discard() {
    BlocProvider.of<ProductCubit>(context).discardChanges(id: id);
  }

  @override
  Future<void> close() {
    nameController.dispose();
    skuController.dispose();
    return super.close();
  }
}
