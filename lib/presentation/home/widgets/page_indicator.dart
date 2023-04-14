import 'package:flutter/material.dart';
import 'package:hiring_test/common/themes/theme.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    Key? key,
    required this.total,
    required this.current,
    this.onNextPage,
    this.onPreviousPage,
  }) : super(key: key);

  final int total;
  final int current;

  final Function()? onNextPage;
  final Function()? onPreviousPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // children: List.generate(total, (index) {
      children: [
        if (onPreviousPage != null)
          IconButton(
            onPressed: current == 0 ? null : onPreviousPage,
            iconSize: 14,
            icon: const Icon(Icons.arrow_back_ios),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Page ${current + 1} / $total',
            style: AppTheme.pageIndicator,
          ),
        ),
        if (onNextPage != null)
          IconButton(
            onPressed: current == total - 1 ? null : onNextPage,
            iconSize: 14,
            icon: const Icon(Icons.arrow_forward_ios),
          ),
      ],
    );
  }
}
