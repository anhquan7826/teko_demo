import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../application/product/product.service.dart';
import '../../../common/themes/theme.dart';
import '../../../common/widgets/image_network_widget.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final product = BlocProvider.of<ProductService>(context).getProduct(id: id)!;
    final changedProduct = BlocProvider.of<ProductService>(context).getProductChanges(id: id);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.imageRadius),
        color: AppTheme.productCardItem,
      ),
      padding: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.goNamed('product', params: {
            'id': id.toString(),
          });
        },
        child: GridTile(
          header: Hero(
            tag: id,
            child: ImageNetworkWidget(url: product.image),
          ),
          footer: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                changedProduct?.name ?? product.name,
                style: AppTheme.productLabel.copyWith(
                  color: changedProduct != null ? Colors.green : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              AutoSizeText(
                product.errorDescription,
                style: AppTheme.productErrorLabel,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
