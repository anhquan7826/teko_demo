import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/application/product/product.cubit.dart';
import 'package:hiring_test/common_widgets/image_network_widget.dart';
import 'package:hiring_test/common_widgets/highlighted_text.dart';
import 'package:hiring_test/presentation/error/not_found.view.dart';

class ProductView extends StatefulWidget {
  const ProductView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    final product = BlocProvider.of<ProductCubit>(context).getProduct(id: widget.id);
    final changedProduct = BlocProvider.of<ProductCubit>(context).getProductChanges(id: widget.id);

    final getColor = BlocProvider.of<ProductCubit>(context).getColor;

    if (product == null) {
      return const NotFoundView(error: 'Product not found!');
    }

    final children = [
      Expanded(
        flex: 2,
        child: Center(
          child: Hero(
            tag: widget.id,
            child: ImageNetworkWidget(
              url: product.image,
            ),
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Column(
          children: [
            HighlightedTextRow(title: 'Name', content: changedProduct?.name ?? product.name),
            HighlightedTextRow(title: 'SKU', content: changedProduct?.sku ?? product.sku),
            if (product.color != -1) HighlightedTextRow(title: 'Color', content: getColor(id: product.color)?.name ?? 'null'),
            HighlightedTextRow(title: 'Error', content: product.errorDescription),
          ],
        ),
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        context.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          actions: [
            IconButton(
              onPressed: () {
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
        body: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
      ),
    );
  }
}
