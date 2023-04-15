import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/product/product.service.dart';
import '../../common/widgets/highlighted_text.dart';
import '../../common/widgets/image_network_widget.dart';
import '../../domain/product/product.model.dart';
import '../../helper/color/color_helper.dart';

class SubmitView extends StatelessWidget {
  const SubmitView({
    Key? key,
    required this.products,
    required this.onApply,
    required this.onDiscard,
  }) : super(key: key);

  final Map<Product, Product> products;
  final Function() onApply;
  final Function() onDiscard;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Apply changes...'),
      content: body(context),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Back'),
        ),
        TextButton(
          onPressed: onDiscard,
          child: const Text('Discard'),
        ),
        TextButton(
          onPressed: onApply,
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget body(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 0.7 * MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).orientation == Orientation.landscape ? 0.6 * MediaQuery.of(context).size.width : double.infinity,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: products.entries.expand((e) {
            return [
              Row(
                children: [
                  image(e.value.image),
                  info(context, product: e),
                ],
              ),
              Divider(
                height: MediaQuery.of(context).orientation == Orientation.landscape ? 14 : 4,
                thickness: 1,
              ),
            ];
          }).toList()..removeLast(),
        ),
      ),
    );
  }

  Widget image(String image) {
    return Expanded(
      child: ImageNetworkWidget(
        url: image,
        borderRadius: 8,
      ),
    );
  }

  Widget info(BuildContext context, {required MapEntry<Product, Product> product}) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HighlightedTextRow(
              content: product.value.name,
              highlighted: product.key.name != product.value.name,
              bold: true,
            ),
            HighlightedTextRow(
              content: product.value.sku,
              highlighted: product.key.sku != product.value.sku,
            ),
            HighlightedTextRow(
              content: BlocProvider.of<ProductService>(context).getColor(id: product.value.color)?.name ?? 'No Color',
              contentLeading: product.value.color == -1
                  ? null
                  : Icon(
                      Icons.circle,
                      color: ColorHelper.fromString(BlocProvider.of<ProductService>(context).getColor(id: product.value.color)?.name ?? ''),
                    ),
              highlighted: product.key.color != product.value.color,
            ),
            HighlightedTextRow(
              content: product.value.errorDescription,
            ),
          ].map((child) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: child,
            );
          }).toList(),
        ),
      ),
    );
  }
}
