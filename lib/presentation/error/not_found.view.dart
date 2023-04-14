import 'package:flutter/material.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({Key? key, required this.error}) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error!'),
      ),
      body: Center(
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_outlined,
              size: 42,
            ),
            Text(error),
          ],
        ),
      ),
    );
  }
}
