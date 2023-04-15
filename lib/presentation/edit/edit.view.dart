import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/application/product/product.service.dart';
import 'package:hiring_test/domain/product_color/product_color.model.dart';
import 'package:hiring_test/helper/color/color_helper.dart';
import 'package:hiring_test/helper/debounce/debounce.dart';

import '../../common/themes/theme.dart';

abstract class EditView extends StatefulWidget {
  factory EditView.color({required int id, required ProductColor selectedColor}) => _ColorFieldEditor(
        id: id,
        selectedColor: selectedColor,
      );

  factory EditView.text(
          {required int id,
          required String title,
          required String label,
          String initialText = '',
          String errorText = 'This field cannot be empty!',
          required int maxLength}) =>
      _TextFieldEditor(
        id: id,
        title: title,
        label: label,
        maxLength: maxLength,
        initialText: initialText,
        errorText: errorText,
      );

  const EditView._({super.key, required this.id, required this.title});

  final int id;
  final String title;
}

class _TextFieldEditor extends EditView {
  const _TextFieldEditor({
    Key? key,
    required int id,
    required String title,
    required this.label,
    this.initialText = '',
    required this.maxLength,
    this.errorText = 'This field cannot be empty!',
  }) : super._(key: key, id: id, title: title);

  final String label;
  final String initialText;
  final int maxLength;
  final String errorText;

  @override
  State<StatefulWidget> createState() => _TextFieldEditorState();
}

class _TextFieldEditorState extends State<_TextFieldEditor> {
  late final TextEditingController controller = TextEditingController(text: widget.initialText);
  final Debounce debounce = Debounce(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        widget.title,
        style: AppTheme.dialogTitle,
      ),
      content: TextField(
        controller: controller,
        maxLength: widget.maxLength,
        style: AppTheme.inputText,
        decoration: InputDecoration(
          errorText: controller.text.isEmpty ? widget.errorText : null,
          label: Text(
            widget.label,
            style: AppTheme.buttonLabel,
          ),
          border: const OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.done,
        onChanged: (value) {
          debounce.run(() => setState(() {}));
        },
        onSubmitted: (value) {
          if (controller.text.isNotEmpty) {
            context.pop(controller.text);
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(
            'Back',
            style: AppTheme.buttonLabel,
          ),
        ),
        TextButton(
          onPressed: () {
            context.pop(controller.text);
          },
          child: Text(
            'Accept',
            style: AppTheme.buttonLabel,
          ),
        ),
      ],
    );
  }
}

class _ColorFieldEditor extends EditView {
  const _ColorFieldEditor({
    Key? key,
    required int id,
    required this.selectedColor,
  }) : super._(key: key, id: id, title: 'Choose colors...');

  final ProductColor selectedColor;

  @override
  State<StatefulWidget> createState() => _ColorFieldEditorState();
}

class _ColorFieldEditorState extends State<_ColorFieldEditor> {
  late ProductColor currentColor = widget.selectedColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        widget.title,
        style: AppTheme.dialogTitle,
      ),
      content: DropdownButtonFormField<ProductColor>(
        items: BlocProvider.of<ProductService>(context).getAllColors().map((color) {
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
        decoration: InputDecoration(
          label: Text(
            'Color',
            style: AppTheme.buttonLabel,
          ),
          border: const OutlineInputBorder(),
        ),
        value: currentColor,
        onChanged: (color) {
          setState(() {
            currentColor = color!;
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(
            'Back',
            style: AppTheme.buttonLabel,
          ),
        ),
        TextButton(
          onPressed: () {
            context.pop(currentColor.id);
          },
          child: Text(
            'Accept',
            style: AppTheme.buttonLabel,
          ),
        ),
      ],
    );
  }
}

// class _EditViewState extends State<EditView> {
//   EditCubit get cubit => BlocProvider.of<EditCubit>(context);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<EditCubit, EditState>(
//       buildWhen: (_, state) => state is EditProductNotFoundState,
//       listener: (context, state) {
//         setState(() {});
//       },
//       builder: (context, state) {
//         if (state is EditProductNotFoundState) {
//           return const NotFoundView(error: 'Product not found!');
//         }
//         return Scaffold(
//           appBar: appBar(),
//           body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: body(),
//           ),
//           bottomNavigationBar: cubit.hasChanges() ? actions() : null,
//         );
//       },
//     );
//   }
//
//   PreferredSizeWidget appBar() {
//     return customAppBar(
//       title: Text(
//         'Edit',
//         style: AppTheme.appbarTitle,
//       ),
//       actions: [
//         if (BlocProvider.of<ProductService>(context).getProductChanges(id: widget.id) != null)
//           TextButton.icon(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return const ConfirmDialog(
//                     content: 'Are you sure to revert your changes to original?',
//                     acceptTitle: 'Revert',
//                     rejectTitle: 'Cancel',
//                   );
//                 },
//               ).then((value) {
//                 if (value == true) {
//                   cubit.revert();
//                 }
//               });
//             },
//             icon: const Icon(Icons.history_outlined),
//             label: Text(
//               'Revert',
//               style: AppTheme.buttonLabel,
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget body() {
//     void onChanged() {
//       cubit.onChanged();
//     }
//
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           textField(
//             label: 'Name',
//             controller: cubit.nameController,
//             onChanged: onChanged,
//             maxLength: 50,
//           ),
//           textField(
//             label: 'SKU',
//             controller: cubit.skuController,
//             onChanged: onChanged,
//             maxLength: 20,
//           ),
//           DropdownButtonFormField<ProductColor>(
//             items: BlocProvider.of<ProductService>(context).getAllColors().map((color) {
//               return DropdownMenuItem<ProductColor>(
//                 value: color,
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Icon(
//                         Icons.circle,
//                         color: ColorHelper.fromString(color.name),
//                       ),
//                     ),
//                     Text(
//                       color.name,
//                       style: AppTheme.inputText,
//                     )
//                   ],
//                 ),
//               );
//             }).toList(),
//             decoration: InputDecoration(
//               label: Text(
//                 'Color',
//                 style: AppTheme.buttonLabel,
//               ),
//               border: const OutlineInputBorder(),
//             ),
//             hint: const Text('Select colors...'),
//             value: cubit.color,
//             onChanged: (color) {
//               cubit.color = color!;
//               onChanged();
//             },
//           ),
//         ].map((child) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             child: child,
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget textField({
//     required TextEditingController controller,
//     required Function() onChanged,
//     required String label,
//     required int maxLength,
//   }) {
//     return TextField(
//       controller: controller,
//       maxLength: maxLength,
//       style: AppTheme.inputText,
//       decoration: InputDecoration(
//           errorText: controller.text.isEmpty ? 'This field cannot be empty!' : null,
//           label: Text(
//             label,
//             style: AppTheme.buttonLabel,
//           ),
//           border: const OutlineInputBorder()),
//       onChanged: (value) {
//         onChanged();
//       },
//     );
//   }
//
//   Widget actions() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 if (cubit.isInvalid()) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         'Name and SKU cannot be empty!',
//                         style: AppTheme.snackBar,
//                       ),
//                     ),
//                   );
//                 } else {
//                   cubit.save();
//                   context.pop();
//                 }
//               },
//               child: Text(
//                 'Save',
//                 style: AppTheme.buttonLabel,
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 14,
//           ),
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 showConfirmDialog();
//               },
//               child: Text(
//                 'Discard',
//                 style: AppTheme.buttonLabel.copyWith(
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showConfirmDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return const ConfirmDialog(
//           content: 'Are you sure to discard your changes?',
//           acceptTitle: 'Discard',
//         );
//       },
//     ).then((value) {
//       if (value == true) {
//         context.pop();
//       }
//     });
//   }
// }
