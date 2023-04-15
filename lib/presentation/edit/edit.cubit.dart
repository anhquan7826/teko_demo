import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiring_test/application/product/product.cubit.dart';
import 'package:hiring_test/helper/debounce/debounce.dart';

import '../../domain/product/product.model.dart';
import '../../domain/product_color/product_color.model.dart';
import 'edit.state.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit(this.context, this.id) : super(const EditInitialState()) {
    if (original == null) {
      emit(const EditProductNotFoundState());
    } else {
      nameController = TextEditingController(text: (changed ?? original!).name);
      skuController = TextEditingController(text: (changed ?? original!).sku);
      color = BlocProvider.of<ProductCubit>(context).getColor(id: (changed ?? original!).color) ?? ProductColor.noColor();
    }
  }

  final BuildContext context;
  final int id;

  Product? get original => BlocProvider.of<ProductCubit>(context).getProduct(id: id);
  Product? get changed => BlocProvider.of<ProductCubit>(context).getProductChanges(id: id);

  late final TextEditingController nameController;
  late final TextEditingController skuController;
  late ProductColor color;

  final debounce = Debounce(milliseconds: 150);

  void onChanged() {
    debounce.run(() {
      emit(EditChangedState(
        color: color.id,
        name: nameController.text,
        sku: skuController.text,
      ));
    });
  }

  bool hasChanges() {
    return nameController.text != (changed ?? original!).name || skuController.text != (changed ?? original!).sku || color.id != (changed ?? original!).color;
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
      product: original!.copyWith(
        name: nameController.text,
        sku: skuController.text,
        color: color.id,
      ),
    );
  }

  void revert() {
    BlocProvider.of<ProductCubit>(context).discardChanges(id: id);
    nameController.text = original!.name;
    skuController.text = original!.sku;
    color = BlocProvider.of<ProductCubit>(context).getColor(id: original!.color) ?? ProductColor.noColor();
    emit(const EditRevertedState());
  }

  @override
  Future<void> close() {
    nameController.dispose();
    skuController.dispose();
    return super.close();
  }
}
