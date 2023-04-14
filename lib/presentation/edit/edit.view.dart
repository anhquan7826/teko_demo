import 'package:flutter/material.dart';

class EditView extends StatefulWidget {
  const EditView({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
    );
  }
}
