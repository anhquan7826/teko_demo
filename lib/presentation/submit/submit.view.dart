import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/product/product.cubit.dart';
import '../../common_widgets/image_network_widget.dart';
import '../../common_widgets/highlighted_text.dart';
import '../../domain/product/product.model.dart';

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
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 0.7 * MediaQuery.of(context).size.height,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: products.entries.map((e) {
              return Row(
                children: [
                  Expanded(
                      child: ImageNetworkWidget(
                    url: e.key.image,
                  )),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        HighlightedTextRow(
                          title: 'Name',
                          content: e.value.name,
                        ),
                        HighlightedTextRow(
                          title: 'SKU',
                          content: e.value.sku,
                        ),
                        HighlightedTextRow(
                          title: 'Color',
                          content: BlocProvider.of<ProductCubit>(context).getColor(id: e.value.color)?.name ?? 'No Color',
                        ),
                        HighlightedTextRow(
                          title: 'Error',
                          content: e.value.errorDescription,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
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
}
