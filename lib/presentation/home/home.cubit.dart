import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiring_test/application/product/product_service.dart';
import 'package:hiring_test/domain/product/product.model.dart';
import 'package:hiring_test/helper/exception/network_exception.dart';
import 'home.state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.context) : super(const HomeInitialState()) {
    loadData();
  }

  final BuildContext context;
  final Map<Product, Product?> products = {};

  Future<void> loadData() async {
    try {
      emit(const HomeLoadingState());
      await ProductService.loadData();
      emit(const HomeLoadedState());
    } on NetworkException catch (e) {
      emit(HomeLoadErrorState(message: e.message));
    }
  }
}
