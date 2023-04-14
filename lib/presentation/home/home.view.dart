import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiring_test/application/product/product_service.dart';
import 'package:sizer/sizer.dart';

import 'home.cubit.dart';
import 'home.state.dart';
import 'widgets/product_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (_, state) {
          return state is HomeLoadingState || state is HomeLoadedState || state is HomeLoadErrorState;
        },
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return Center(
              child: SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(),
              ),
            );
          } else if (state is HomeLoadErrorState) {
            return Center(
              child: Column(
                children: [
                  const Text(
                    'Cannot load products!',
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Reload'),
                  ),
                ],
              ),
            );
          } else {
            return GridView.count(
              crossAxisCount: () {
                switch (SizerUtil.deviceType) {
                  case DeviceType.mobile:
                    return SizerUtil.orientation == Orientation.portrait ? 2 : 4;
                  case DeviceType.tablet:
                    return SizerUtil.orientation == Orientation.portrait ? 4 : 6;
                  default:
                    return 6;
                }
              }.call(),
              children: ProductService.getAllProductIds().map((id) {
                return ProductItem(
                  id: id,
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
