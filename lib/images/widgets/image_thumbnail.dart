import 'package:flutter/material.dart';

import '../../models/image.dart';

class ImageThumbnail extends StatelessWidget {
  final ImageRef image;
  final bool isThumbnail;
  final double height;
  final double width;
  ImageThumbnail(this.image, this.isThumbnail, this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return Hero(
      child: Image(
        image: NetworkImage(isThumbnail ? image.downloadUrlTN : image.downloadUrl),
        height: height,
        width: width,
        fit: BoxFit.fitWidth,
      ),
      tag: image.id,
    );
  }
}
