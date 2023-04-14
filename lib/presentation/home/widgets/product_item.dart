import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiring_test/presentation/product/product.view.dart';

import '../../../application/product/product.cubit.dart';
import '../../../common/themes/theme.dart';
import '../../../common/widgets/image_network_widget.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final product = BlocProvider.of<ProductCubit>(context).getProduct(id: id)!;
    final changedProduct = BlocProvider.of<ProductCubit>(context).getProductChanges(id: id);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.imageRadius),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return ProductView(id: product.id,);
            },
          );
        },
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: ImageNetworkWidget(url: product.image),
              ),
            ),
            Expanded(
              child: AutoSizeText(
                changedProduct?.name ?? product.name,
                style: TextStyle(
                  color: changedProduct?.name != null && changedProduct?.name != product.name ? Colors.green : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
