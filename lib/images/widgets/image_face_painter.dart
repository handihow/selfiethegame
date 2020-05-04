import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:selfiespel_mobile/models/mask.dart';

class FacePainter extends CustomPainter {
  final List<Mask> masks;
  final List<ui.Image> images;

  FacePainter(this.masks, this.images);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    if (this.masks != null) {
      // final Paint paint = Paint()
      //   ..style = PaintingStyle.stroke
      //   ..strokeWidth = 15.0
      //   ..color = Colors.yellow;
      
      for (var i = 0; i < masks.length; i++) {

        final Rect imageRect = Rect.fromLTRB(0, 0, images[i].width.toDouble(), images[i].height.toDouble());
        final Rect maskRect = Rect.fromLTRB(masks[i].left, masks[i].top, masks[i].right, masks[i].bottom);
        // final Paint maskPaint = Paint()
        // ..colorFilter = ColorFilter.mode(colors[i], BlendMode.modulate);
        // canvas.drawRect(rects[i], paint);
        canvas.drawImageRect(
            images[i], imageRect, maskRect, Paint());
      }
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return masks != oldDelegate.masks;
  }

}
