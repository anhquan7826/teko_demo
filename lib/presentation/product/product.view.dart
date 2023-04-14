import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/application/product/product_service.dart';
import 'package:hiring_test/presentation/error/not_found.view.dart';
import 'package:sizer/sizer.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key, required this.id,}) : super(key: key);

  final int id;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    final product = ProductService.getProduct(id: widget.id);
    final changedProduct = ProductService.getProductChanges(id: widget.id);

    if (product == null) {
      return const NotFoundView(error: 'Product not found!');
    }

    final children = [
      Expanded(
        flex: 2,
        child: Center(
          child: Hero(
            tag: widget.id,
            child: Image.network(
              product.image,
              errorBuilder: (context, exception, stacktrace) {
                return Image.asset('assets/images/error.png');
              },
            ),
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Column(
          children: [
            row(title: 'Name', content: product.name),
            row(title: 'SKU', content: product.sku),
            if (product.color != null) row(title: 'Color', content: ProductService.getColor(id: product.color!)?.name ?? 'null'),
            row(title: 'Error', content: product.errorDescription),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            onPressed: () {
              // context.go('edit', extra: widget.product);
              context.goNamed(
                'edit',
                params: {
                  'id': widget.id.toString(),
                },
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SizerUtil.orientation == Orientation.portrait
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
    );
  }

  Row row({required String title, required String content}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(content),
        ),
      ],
    );
  }
}
