import 'package:flutter/material.dart';
import 'package:hiring_test/common/themes/theme.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({Key? key, required this.error}) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Error!',
          style: AppTheme.appbarTitle,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_outlined,
              size: 42,
            ),
            Text(
              error,
              style: AppTheme.bodyText,
            ),
          ],
        ),
      ),
    );
  }
}
