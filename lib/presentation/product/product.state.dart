import 'package:equatable/equatable.dart';

abstract class ProductEditingState extends Equatable {
  const ProductEditingState();
}

class ProductEditingInitialState extends ProductEditingState {
  const ProductEditingInitialState();

  @override
  List<Object?> get props => [];
}

class ProductEditNotFoundState extends ProductEditingState {
  const ProductEditNotFoundState();

  @override
  List<Object?> get props => [];
}

class ProductEditChangedState extends ProductEditingState {
  const ProductEditChangedState({
    required this.name,
    required this.sku,
    required this.color,
  });

  final int color;
  final String name;
  final String sku;

  @override
  List<Object?> get props => [color, name, sku];
}

class ProductEditRevertedState extends ProductEditingState {
  const ProductEditRevertedState();

  @override
  List<Object?> get props => [];
}
