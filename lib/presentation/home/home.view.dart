import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/application/product/product.cubit.dart';
import 'package:hiring_test/application/product/product.state.dart';
import 'package:hiring_test/common_widgets/confirm_dialog.dart';
import 'package:hiring_test/presentation/home/widgets/page_indicator.dart';
import 'package:hiring_test/presentation/submit/submit.view.dart';

import 'widgets/product_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoadingState) {
          return Scaffold(
            body: Center(
              child: SizedBox.square(
                dimension: 0.2 * MediaQuery.of(context).size.width,
                child: const CircularProgressIndicator(),
              ),
            ),
          );
        } else if (state is ProductLoadErrorState) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Cannot load products!',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<ProductCubit>(context).loadData();
                    },
                    child: const Text('Reload'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Product'),
            ),
            body: body(context),
            bottomNavigationBar: BlocProvider.of<ProductCubit>(context).hasChanges()
                ? ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SubmitView(
                            products: BlocProvider.of<ProductCubit>(context).getAllChanges(),
                            onApply: () {
                              BlocProvider.of<ProductCubit>(context).applyChanges();
                              context.pop();
                            },
                            onDiscard: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const ConfirmDialog(
                                    content: 'Are you sure to discard all changes?',
                                    acceptTitle: 'Discard',
                                    rejectTitle: 'Cancel',
                                  );
                                },
                              ).then((value) {
                                if (value == true) {
                                  BlocProvider.of<ProductCubit>(context).discardChanges();
                                  context.pop();
                                }
                              });
                            },
                          );
                        },
                      );
                    },
                    child: const Text('Submit'),
                  )
                : null,
          );
        }
      },
    );
  }

  int currentIndex = 0;

  Widget body(BuildContext context) {
    final products = BlocProvider.of<ProductCubit>(context).getAllProductIds();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PageIndicator(total: (products.length / 10).ceil(), current: currentIndex),
        Expanded(
          child: PageView(
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            children: List.generate((products.length / 10).ceil(), (index) {
              return GridView.count(
                crossAxisCount: () {
                  if (kIsWeb) {
                    return 4;
                  } else if (Platform.isAndroid || Platform.isIOS) {
                    switch (MediaQuery.of(context).orientation) {
                      case Orientation.portrait:
                        return 2;
                      default:
                        return 3;
                    }
                  }
                  return 4;
                }.call(),
                children: products.getRange(10 * index, 10 * index + 10 > products.length ? products.length : 10 * index + 10).map((id) {
                  return ProductItem(
                    id: id,
                  );
                }).toList(),
              );
            }),
          ),
        ),
      ],
    );
  }
}
