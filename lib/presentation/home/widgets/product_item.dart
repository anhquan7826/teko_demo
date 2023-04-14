import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/common_widgets/image_network_widget.dart';

import '../../../application/product/product.cubit.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final product = BlocProvider.of<ProductCubit>(context).getProduct(id: id)!;
    final changedProduct = BlocProvider.of<ProductCubit>(context).getProductChanges(id: id);

    return InkWell(
      onTap: () {
        context.goNamed(
          'product',
          params: {
            'id': product.id.toString(),
          },
        );
      },
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: SizedBox(
              height: double.infinity,
              child: Hero(
                tag: product.id,
                child: ImageNetworkWidget(url: product.image),
              ),
            ),
          ),
          Flexible(
            child: Column(
              children: [
                AutoSizeText(
                  changedProduct?.name ?? product.name,
                  style: TextStyle(
                    color: changedProduct?.name != null && changedProduct?.name != product.name ? Colors.green : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
