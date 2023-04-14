import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/application/product/product.cubit.dart';
import 'package:hiring_test/helper/color/color_helper.dart';
import 'package:hiring_test/presentation/error/not_found.view.dart';

import '../../common/themes/theme.dart';
import '../../common/widgets/highlighted_text.dart';
import '../../common/widgets/image_network_widget.dart';

class ProductView extends StatelessWidget {
  const ProductView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final product = BlocProvider.of<ProductCubit>(context).getProduct(id: id);
    final changedProduct = BlocProvider.of<ProductCubit>(context).getProductChanges(id: id);

    final getColor = BlocProvider.of<ProductCubit>(context).getColor;

    if (product == null) {
      return const NotFoundView(error: 'Product not found!');
    }

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    final children = [
      Center(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: isPortrait ? 14 : 0,
            right: !isPortrait ? 14 : 0,
          ),
          child: ImageNetworkWidget(
            url: product.image,
          ),
        ),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HighlightedTextRow(
                  title: 'Name',
                  content: changedProduct?.name ?? product.name,
                  highlighted: changedProduct != null && product.name != changedProduct.name,
                ),
                HighlightedTextRow(
                  title: 'SKU',
                  content: changedProduct?.sku ?? product.sku,
                  highlighted: changedProduct != null && product.sku != changedProduct.sku,
                ),
                    () {
                  final color = getColor(id: changedProduct?.color ?? product.color);
                  return HighlightedTextRow(
                    title: 'Color',
                    contentLeading: color?.id == -1
                        ? null
                        : Icon(
                      Icons.circle,
                      color: ColorHelper.fromString(color?.name ?? ''),
                    ),
                    content: color?.name ?? 'null',
                    highlighted: changedProduct != null && product.color != changedProduct.color,
                  );
                }.call(),
                HighlightedTextRow(
                  title: 'Error',
                  content: product.errorDescription,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                context.goNamed(
                  'edit',
                  params: {
                    'id': id.toString(),
                  },
                );
              },
              icon: const Icon(Icons.edit_outlined),
              label: Text(
                'Edit',
                style: AppTheme.buttonLabel,
              ),
            ),
          ),
        ],
      ),
    ];

    return Hero(
      tag: id,
      child: Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: isPortrait ? 0.7 * MediaQuery.of(context).size.height : double.infinity,
            maxWidth: !isPortrait ? 0.7 * MediaQuery.of(context).size.width : double.infinity,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: isPortrait
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: children.map((child) {
                return Expanded(child: child);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }}
