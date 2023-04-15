import 'package:flutter/material.dart';
import 'package:hiring_test/common/themes/theme.dart';

class HighlightedTextRow extends StatelessWidget {
  const HighlightedTextRow({
    Key? key,
    this.title,
    required this.content,
    this.highlighted = false,
    this.contentLeading,
    this.fontSize,
    this.bold = false,
  }) : super(key: key);

  final String? title;
  final String content;
  final Widget? contentLeading;
  final bool highlighted;
  final double? fontSize;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Expanded(
            // flex: 2,
            child: Text(
              title!,
              style: AppTheme.bodyText.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: fontSize,
              ),
            ),
          ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (contentLeading != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: contentLeading!,
                ),
              Expanded(
                child: Text(
                  content,
                  style: AppTheme.bodyText.copyWith(
                    fontWeight: bold ? FontWeight.w700 : null,
                    color: highlighted ? AppTheme.highlightColor : null,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
