import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../models/image.dart';

class RotatedImage extends StatelessWidget {
  final ImageRef image;
  final double size;
  final bool isThumbnail;

  RotatedImage(this.image, this.size, this.isThumbnail);

  @override
  Widget build(BuildContext context) {
    double angle;
    switch (image.imageState) {
      case '90':
        angle = math.pi / 2;
        break;
      case '180':
        angle = math.pi;
        break;
      case '270':
        angle = math.pi * 3 / 2;
        break;
      default:
        angle = 0;
        break;
    }
    return Hero(
      tag: image.id,
      child: Transform.rotate(
        angle: angle,
        child: Image.network(
          isThumbnail && image.downloadUrlTN != null
              ? image.downloadUrlTN
              : image.downloadUrl != null
                  ? image.downloadUrl
                  : 'https://via.placeholder.com/500x500.png?text=Image not available...',
          fit: BoxFit.cover,
          width: size,
        ),
      ),
    );
  }
}
