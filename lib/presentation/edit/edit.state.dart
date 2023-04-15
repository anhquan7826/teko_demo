import 'package:equatable/equatable.dart';

abstract class EditState extends Equatable {
  const EditState();
}

class EditInitialState extends EditState {
  const EditInitialState();

  @override
  List<Object?> get props => [];
}

class EditProductNotFoundState extends EditState {
  const EditProductNotFoundState();

  @override
  List<Object?> get props => [];
}

class EditChangedState extends EditState {
  const EditChangedState({
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

class EditRevertedState extends EditState {
  const EditRevertedState();

  @override
  List<Object?> get props => [];
}
