import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final List<Color> colors;
  final List<Rect> rects = [];
  final ui.Image mask;

  FacePainter(this.faces, this.mask, this.colors) {
    if (this.faces != null) {
      for (var i = 0; i < faces.length; i++) {
        rects.add(faces[i].boundingBox);
      }
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    if (this.faces != null) {
      // final Paint paint = Paint()
      //   ..style = PaintingStyle.stroke
      //   ..strokeWidth = 15.0
      //   ..color = Colors.yellow;
      final Rect maskRect = Rect.fromLTRB(0, 0, mask.width.toDouble(), mask.height.toDouble());

      for (var i = 0; i < faces.length; i++) {
        final Paint maskPaint = Paint()
        ..colorFilter = ColorFilter.mode(colors[i], BlendMode.modulate);
        // canvas.drawRect(rects[i], paint);
        canvas.drawImageRect(
            mask, maskRect, rects[i], maskPaint);
      }
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return faces != oldDelegate.faces;
  }
}
