import 'package:flutter/cupertino.dart';

class HighlightedTextRow extends StatelessWidget {
  const HighlightedTextRow({Key? key, required this.title, required this.content, this.highlighted = false,}) : super(key: key);

  final String title;
  final String content;

  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(content),
        ),
      ],
    );
  }
}
