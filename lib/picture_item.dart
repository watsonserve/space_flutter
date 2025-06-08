import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PictureItem extends StatelessWidget {
  final String imageUrl;
  final Null Function() onPressed;

  const PictureItem({
    super.key,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator()
        ),
        errorWidget: (context, url, error) => Center(
          child: Icon(
            Icons.error,
            size: 16
          ),
        ),
      ),
      onTap: () {
        onPressed();
      },
    );
  }
}
