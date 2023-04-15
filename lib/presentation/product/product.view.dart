import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/application/product/product.service.dart';
import 'package:hiring_test/common/widgets/custom_appbar.dart';
import 'package:hiring_test/helper/color/color_helper.dart';
import 'package:hiring_test/presentation/error/not_found.view.dart';
import 'package:hiring_test/presentation/product/product.cubit.dart';
import 'package:hiring_test/presentation/product/product.state.dart';

import '../../common/themes/theme.dart';
import '../../common/widgets/confirm_dialog.dart';
import '../../common/widgets/image_network_widget.dart';
import '../../domain/product/product.model.dart';
import '../../domain/product_color/product_color.model.dart';
import '../edit/edit.view.dart';

class ProductView extends StatefulWidget {
  const ProductView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<StatefulWidget> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  ProductCubit get cubit => BlocProvider.of<ProductCubit>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductEditingState>(
      builder: (context, state) {
        if (state is ProductEditNotFoundState) {
          return const NotFoundView(error: 'Product not found!');
        }
        return WillPopScope(
          onWillPop: () async {
            if (cubit.hasChanges()) {
              showConfirmDialog();
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar(),
            body: body(
              context,
              children: [
                image(
                  context,
                  image: cubit.original!.image,
                ),
                info(
                  context,
                  product: cubit.original!,
                  changedProduct: cubit.changed,
                ),
              ],
            ),
            bottomNavigationBar: cubit.hasChanges() ? actions() : null,
          ),
        );
      },
    );
  }

  PreferredSizeWidget appBar() {
    return customAppBar(
      title: Text(
        'Product Detail',
        style: AppTheme.appbarTitle,
      ),
      actions: [
        if (BlocProvider.of<ProductService>(context).getProductChanges(id: widget.id) != null)
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const ConfirmDialog(
                    content: 'Are you sure to revert your changes to original?',
                    acceptTitle: 'Revert',
                    rejectTitle: 'Cancel',
                  );
                },
              ).then((value) {
                if (value == true) {
                  cubit.revert();
                }
              });
            },
            icon: const Icon(Icons.history_outlined),
            label: Text(
              'Revert',
              style: AppTheme.buttonLabel,
            ),
          ),
      ],
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
        child: Hero(
          tag: widget.id,
          child: ImageNetworkWidget(
            zoomOnTap: true,
            url: image,
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
    TableRow tableRow({required String title, required String content, bool highlighted = false, Function()? onEdit, Widget? contentLeading}) {
      return TableRow(
        children: [
          Text(
            title,
            style: AppTheme.tableTitle,
          ),
          InkWell(
            onTap: onEdit,
            child: Row(
              children: [
                if (contentLeading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: contentLeading,
                  ),
                Expanded(
                  child: Text(
                    content,
                    style: AppTheme.tableContent.copyWith(
                      color: highlighted ? AppTheme.highlightColor : null,
                    ),
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    iconSize: AppTheme.editIcon,
                    icon: const Icon(
                      Icons.edit_rounded,
                    ),
                  ),
              ],
            ),
          ),
        ].map((child) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: child,
          );
        }).toList(),
      );
    }

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final table = Table(
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(3),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        tableRow(
          title: 'ID',
          content: product.id.toString(),
        ),
        tableRow(
          title: 'Name',
          content: cubit.name,
          highlighted: cubit.highlightName,
          onEdit: () {
            showDialog(
              context: context,
              builder: (context) {
                return EditView.text(
                  id: widget.id,
                  title: 'Edit name...',
                  label: 'Name',
                  maxLength: 50,
                  initialText: changedProduct?.name ?? product.name,
                );
              },
            ).then((value) {
              if (value != null) {
                cubit.setValue(name: value.toString());
              }
            });
          },
        ),
        tableRow(
          title: 'SKU',
          content: cubit.sku,
          highlighted: cubit.highlightSKU,
          onEdit: () {
            showDialog(
              context: context,
              builder: (context) {
                return EditView.text(
                  id: widget.id,
                  title: 'Edit SKU...',
                  label: 'SKU',
                  maxLength: 20,
                  initialText: changedProduct?.sku ?? product.sku,
                );
              },
            ).then((value) {
              if (value != null) {
                cubit.setValue(sku: value.toString());
              }
            });
          },
        ),
        () {
          final color = BlocProvider.of<ProductService>(context).getColor(id: cubit.color);
          return tableRow(
            title: 'Color',
            contentLeading: color?.id == -1
                ? null
                : Icon(
                    Icons.circle,
                    color: ColorHelper.fromString(color?.name ?? ''),
                  ),
            content: color?.name ?? 'null',
            highlighted: cubit.highlightColor,
            onEdit: () {
              showDialog(
                context: context,
                builder: (context) {
                  return EditView.color(
                    id: widget.id,
                    selectedColor: color ?? ProductColor.noColor(),
                  );
                },
              ).then((value) {
                if (value != null) {
                  cubit.setValue(color: int.parse(value.toString()));
                }
              });
            },
          );
        }.call(),
        tableRow(
          title: 'Error',
          content: product.errorDescription,
        ),
      ],
    );

    if (isPortrait) {
      return table;
    } else {
      return SingleChildScrollView(
        child: table,
      );
    }
  }

  Widget actions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (cubit.isInvalid()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Name and SKU cannot be empty!',
                        style: AppTheme.snackBar,
                      ),
                    ),
                  );
                } else {
                  cubit.save();
                  context.pop();
                }
              },
              child: Text(
                'Save',
                style: AppTheme.buttonLabel,
              ),
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                showConfirmDialog();
              },
              child: Text(
                'Discard',
                style: AppTheme.buttonLabel.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const ConfirmDialog(
          content: 'Are you sure to discard your changes?',
          acceptTitle: 'Discard',
        );
      },
    ).then((value) {
      if (value == true) {
        context.pop();
      }
    });
  }
}
