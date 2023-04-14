import 'package:flutter/material.dart';

class ImageNetworkWidget extends StatelessWidget {
  const ImageNetworkWidget({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
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
        return child;
      },
      errorBuilder: (context, _, __) {
        return Image.asset('assets/images/error.png');
      },
    );
  }
}
