import 'package:equatable/equatable.dart';

import '../../domain/product/product.model.dart';

abstract class ProductState extends Equatable {
  const ProductState();
}

class ProductInitialState extends ProductState {
  const ProductInitialState();

  @override
  List<Object?> get props => [];
}

class ProductLoadingState extends ProductState {
  const ProductLoadingState();

  @override
  List<Object?> get props => [];
}

class ProductLoadedState extends ProductState {
  const ProductLoadedState();

  @override
  List<Object?> get props => [];
}

class ProductLoadErrorState extends ProductState {
  const ProductLoadErrorState();

  @override
  List<Object?> get props => [];
}

class ProductChangedState extends ProductState {
  const ProductChangedState(this.product);

  final Product product;

  @override
  List<Object?> get props => [product.name, product.sku, product.id];
}

class ProductDiscardedState extends ProductState {
  const ProductDiscardedState([this.id]);

  final int? id;
  
  @override
  List<Object?> get props => [id];
}

class ProductAppliedState extends ProductState {
  const ProductAppliedState();

  @override
  List<Object?> get props => [];
}