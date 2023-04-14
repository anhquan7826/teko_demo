import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/application/product/product.cubit.dart';
import 'package:hiring_test/domain/product_color/product_color.model.dart';
import 'package:hiring_test/helper/color/color_helper.dart';
import 'package:hiring_test/helper/debounce/debounce.dart';
import 'package:hiring_test/presentation/edit/edit.cubit.dart';
import 'package:hiring_test/presentation/edit/edit.state.dart';
import 'package:hiring_test/presentation/error/not_found.view.dart';

import '../../common/themes/theme.dart';
import '../../common/widgets/confirm_dialog.dart';

class EditView extends StatefulWidget {
  const EditView({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  EditCubit get cubit => BlocProvider.of<EditCubit>(context);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        cubit.hasChanges() ? showConfirmDialog() : context.pop();
        return false;
      },
      child: BlocConsumer<EditCubit, EditState>(
        buildWhen: (_, state) => state is EditProductNotFoundState,
        listener: (context, state) {
          if (state is EditChangedState) {
            setState(() {});
          }
        },
        builder: (context, state) {
          if (state is EditProductNotFoundState) {
            return const NotFoundView(error: 'Product not found!');
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Edit',
                style: AppTheme.appbarTitle,
              ),
            ),
            body: body(),
            bottomNavigationBar: cubit.hasChanges() ? actions() : null,
          );
        },
      ),
    );
  }

  Widget body() {
    void onChanged() {
      Debounce(milliseconds: 100).run(
        () {
          cubit.onChanged();
        },
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          textField(
            label: 'Name',
            controller: cubit.nameController,
            onChanged: onChanged,
            maxLength: 50,
          ),
          textField(
            label: 'SKU',
            controller: cubit.skuController,
            onChanged: onChanged,
            maxLength: 20,
          ),
          DropdownButtonFormField<ProductColor>(
            items: BlocProvider.of<ProductCubit>(context).getAllColors().map((color) {
              return DropdownMenuItem<ProductColor>(
                value: color,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        Icons.circle,
                        color: ColorHelper.fromString(color.name),
                      ),
                    ),
                    Text(
                      color.name,
                      style: AppTheme.inputText,
                    )
                  ],
                ),
              );
            }).toList(),
            decoration: const InputDecoration(border: OutlineInputBorder()),
            hint: const Text('Select colors...'),
            value: cubit.color,
            onChanged: (color) {
              cubit.color = color!;
              onChanged();
            },
          ),
        ],
      ),
    );
  }

  Widget textField({
    required TextEditingController controller,
    required Function() onChanged,
    required String label,
    required int maxLength,
  }) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      style: AppTheme.inputText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: controller.text.isEmpty ? Colors.red : Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: controller.text.isEmpty ? Colors.red : Colors.blue,
            width: 2,
          ),
        ),
        label: Text(
          label,
          style: AppTheme.buttonLabel,
        ),
        focusColor: Colors.red,
      ),
      onChanged: (value) {
        Debounce(milliseconds: 100).run(onChanged);
      },
    );
  }

  Widget actions() {
    return Row(
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
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showConfirmDialog();
            },
            child: Text(
              'Discard',
              style: AppTheme.buttonLabel,
            ),
          ),
        ),
      ],
    );
  }

  void showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const ConfirmDialog(
          content: 'Are you sure to discard your changes?',
        );
      },
    ).then((value) {
      if (value == true) {
        cubit.discard();
        context.pop();
      }
    });
  }
}
