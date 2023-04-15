import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/application/product/product.cubit.dart';
import 'package:hiring_test/common/widgets/custom_appbar.dart';
import 'package:hiring_test/common/widgets/zoom_image.dart';
import 'package:hiring_test/helper/color/color_helper.dart';
import 'package:hiring_test/presentation/error/not_found.view.dart';

import '../../common/themes/theme.dart';
import '../../common/widgets/highlighted_text.dart';
import '../../common/widgets/image_network_widget.dart';
import '../../domain/product/product.model.dart';

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

    if (product == null) {
      return const NotFoundView(error: 'Product not found!');
    }

    return Scaffold(
      appBar: appBar(),
      body: body(
        context,
        children: [
          image(
            context,
            image: product.image,
          ),
          info(
            context,
            product: product,
            changedProduct: changedProduct,
          ),
        ],
      ),
      floatingActionButton: editButton(context),
    );
  }

  PreferredSizeWidget appBar() {
    return customAppBar(
      title: Text(
        'Product Detail',
        style: AppTheme.appbarTitle,
      ),
    );
  }

  Widget body(BuildContext context, {required List<Widget> children}) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: isPortrait
          ? SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: children.map((child) {
                return Expanded(child: child);
              }).toList(),
            ),
    );
  }

  Widget editButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        context.goNamed(
          'edit',
          params: {
            'id': id.toString(),
          },
        );
      },
      label: Text(
        'Edit',
        style: AppTheme.buttonLabel,
      ),
      icon: const Icon(Icons.edit_outlined),
    );
  }

  Widget image(
    BuildContext context, {
    required String image,
  }) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: isPortrait ? 16 : 0,
          right: !isPortrait ? 16 : 0,
        ),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return ZoomImageDialog(image: image);
              },
            );
          },
          child: Hero(
            tag: id,
            child: ImageNetworkWidget(
              url: image,
            ),
          ),
        ),
      ),
    );
  }

  Widget info(
    BuildContext context, {
    required Product product,
    Product? changedProduct,
  }) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final widget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HighlightedTextRow(
          title: 'Name',
          content: changedProduct?.name ?? product.name,
          highlighted: changedProduct != null && product.name != changedProduct.name,
          fontSize: 16,
        ),
        HighlightedTextRow(
          title: 'SKU',
          content: changedProduct?.sku ?? product.sku,
          highlighted: changedProduct != null && product.sku != changedProduct.sku,
          fontSize: 16,
        ),
        () {
          final color = BlocProvider.of<ProductCubit>(context).getColor(id: changedProduct?.color ?? product.color);
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
            fontSize: 16,
          );
        }.call(),
        HighlightedTextRow(
          title: 'Error',
          content: product.errorDescription,
          fontSize: 16,
        ),
      ].map((child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: child,
        );
      }).toList(),
    );
    if (isPortrait) {
      return widget;
    } else {
      return SingleChildScrollView(
        child: widget,
      );
    }
  }
}
