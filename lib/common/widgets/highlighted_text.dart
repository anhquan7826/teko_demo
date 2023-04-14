import 'package:flutter/material.dart';
import 'package:hiring_test/common/themes/theme.dart';

class HighlightedTextRow extends StatelessWidget {
  const HighlightedTextRow({
    Key? key,
    this.title,
    required this.content,
    this.highlighted = false,
    this.contentLeading,
  }) : super(key: key);

  final String? title;
  final String content;
  final Widget? contentLeading;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Expanded(
            child: Text(
              title!,
              style: AppTheme.bodyText.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (contentLeading != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: contentLeading!,
          ),
        Expanded(
          flex: 3,
          child: Text(
            content,
            textAlign: title == null ? TextAlign.center : null,
            style: AppTheme.bodyText.copyWith(
              fontWeight: title == null ? FontWeight.w700 : null,
              color: highlighted ? AppTheme.highlightColor : null,
            ),
          ),
        ),
      ],
    );
  }
}
