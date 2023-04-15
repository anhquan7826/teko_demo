import 'package:flutter/material.dart';

class ZoomImageDialog extends StatelessWidget {
  const ZoomImageDialog({Key? key, required this.image}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: InteractiveViewer(
        clipBehavior: Clip.none,
        maxScale: 3,
        child: Image.network(image),
      ),
    );
  }
}
