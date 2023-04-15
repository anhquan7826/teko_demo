import 'package:flutter/material.dart';

import '../themes/theme.dart';

class ImageNetworkWidget extends StatelessWidget {
  const ImageNetworkWidget({
    Key? key,
    required this.url,
    this.borderRadius = AppTheme.imageRadius,
    this.zoomOnTap = false,
  }) : super(key: key);

  final String url;
  final double borderRadius;
  final bool zoomOnTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: !Uri.parse(url).isAbsolute
          ? Image.asset('assets/images/error.png')
          : Image.network(
              url,
              loadingBuilder: (context, child, chunk) {
                if (chunk != null) {
                  if (chunk.expectedTotalBytes == null) {
                    return const Center(
                      child: SizedBox.square(
                        dimension: 32,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Center(
                      child: SizedBox.square(
                        dimension: 32,
                        child: CircularProgressIndicator(
                          value: chunk.cumulativeBytesLoaded / chunk.expectedTotalBytes!,
                        ),
                      ),
                    );
                  }
                }
                return GestureDetector(
                  onTap: !zoomOnTap
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: InteractiveViewer(
                                  clipBehavior: Clip.none,
                                  maxScale: 3,
                                  child: Image.network(url),
                                ),
                              );
                            },
                          );
                        },
                  child: child,
                );
              },
              errorBuilder: (context, _, __) {
                return Image.asset('assets/images/error.png');
              },
            ),
    );
  }
}
