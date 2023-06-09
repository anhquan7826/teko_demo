import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/application/product/product.service.dart';
import 'package:hiring_test/application/product/product.service.state.dart';
import 'package:hiring_test/common/themes/theme.dart';
import 'package:hiring_test/common/widgets/custom_appbar.dart';
import 'package:hiring_test/helper/boundary/boundary.dart';
import 'package:hiring_test/presentation/home/widgets/page_indicator.dart';
import 'package:hiring_test/presentation/submit/submit.view.dart';

import '../../common/widgets/confirm_dialog.dart';
import 'widgets/product_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductService, ProductState>(
      builder: (context, state) {
        if (state is ProductLoadingState) {
          return Scaffold(
            appBar: appBar(),
            body: Center(
              child: SizedBox.square(
                dimension: 0.15 * MediaQuery.of(context).size.width,
                child: const CircularProgressIndicator(),
              ),
            ),
          );
        } else if (state is ProductLoadErrorState) {
          return Scaffold(
            appBar: appBar(),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Icon(
                      Icons.error,
                      size: 48,
                    ),
                  ),
                  Text(
                    'Cannot load products!',
                    style: AppTheme.bodyText,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<ProductService>(context).loadData();
                    },
                    child: Text(
                      'Reload',
                      style: AppTheme.buttonLabel,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar(),
            body: body(context),
            bottomNavigationBar: BlocProvider.of<ProductService>(context).hasChanges()
                ? submit()
                : null,
          );
        }
      },
    );
  }

  PreferredSizeWidget appBar() {
    return customAppBar(
      title: Text(
        'Product',
        style: AppTheme.appbarTitle,
      ),
    );
  }

  Widget body(BuildContext context) {
    final products = BlocProvider.of<ProductService>(context).getAllProductIds();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: List.generate((products.length / 10).ceil(), (index) {
                return GridView.count(
                  childAspectRatio: 3 / 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  crossAxisCount: () {
                    if (kIsWeb) {
                      return ValueBoundary.bound(
                        min: 2,
                        max: 5,
                        value: MediaQuery.of(context).size.width / 300,
                      ).toInt();
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
          PageIndicator(
            total: (products.length / 10).ceil(),
            current: currentIndex,
            onNextPage: () {
              pageController.animateToPage(
                currentIndex + 1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
              );
            },
            onPreviousPage: () {
              pageController.animateToPage(
                currentIndex - 1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget submit() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.2 * MediaQuery.of(context).size.width,
        vertical: 8,
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return SubmitView(
                products: BlocProvider.of<ProductService>(context).getAllChanges(),
                onApply: () {
                  BlocProvider.of<ProductService>(context).applyChanges();
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
                      BlocProvider.of<ProductService>(context).discardChanges();
                      context.pop();
                    }
                  });
                },
              );
            },
          );
        },
        icon: const Icon(
          Icons.done_rounded,
        ),
        label: Text(
          'Submit',
          style: AppTheme.buttonLabel,
        ),
      ),
    );
  }
}
