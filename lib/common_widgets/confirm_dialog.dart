import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    this.title = 'Warning!',
    required this.content,
    this.acceptTitle = 'Accept',
    this.rejectTitle = 'Back',
  }) : super(key: key);

  final String title;
  final String content;
  final String acceptTitle;
  final String rejectTitle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            context.pop(false);
          },
          child: Text(rejectTitle),
        ),
        TextButton(
          onPressed: () {
            context.pop(true);
          },
          child: Text(acceptTitle),
        ),
      ],
    );
  }
}
