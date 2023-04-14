import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../application/product/product_service.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({required this.id, Key? key}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final product = ProductService.getProduct(id: id);
    final changedProduct = ProductService.getProductChanges(id: id);

    if (product == null) {
      return const Center(
        child: Icon(Icons.error_outline_outlined),
      );
    }

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
                child: Image.network(
                  product.image,
                  errorBuilder: (context, exception, stacktrace) {
                    return Image.asset('assets/images/error.png');
                  },
                ),
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
