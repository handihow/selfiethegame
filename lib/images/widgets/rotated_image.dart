import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selfiespel_mobile/models/mask.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../../models/image.dart';
import 'image_face_painter.dart';

class RotatedImage extends StatefulWidget {
  final ImageRef image;
  final double size;
  final bool isThumbnail;

  RotatedImage(this.image, this.size, this.isThumbnail);

  @override
  _RotatedImageState createState() => _RotatedImageState();
}

class _RotatedImageState extends State<RotatedImage> {
  bool _doneLoading = false;
  bool _hasNoImage = false;
  double _angle = 0;
  bool _hasMasks = false;
  List<Mask> _masks;
  List<ui.Image> _images;

  @override
  initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    if ((widget.isThumbnail && widget.image.downloadUrlTN == null) ||
        (!widget.isThumbnail && widget.image.downloadUrl == null)) {
      setState(() {
        _doneLoading = true;
        _hasNoImage = true;
      });
    } else {
      double angle;
      switch (widget.image.imageState) {
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
      List<ui.Image> images;
      if (widget.image.hasMasks != null && widget.image.hasMasks) {
        images = await _loadImages(widget.image.masks);
      }
      if (mounted) {
        setState(
          () {
            _doneLoading = true;
            _angle = angle;
            _images = images != null ? images : null;
            _masks = widget.image.masks != null ? widget.image.masks : null;
            _hasMasks =
                widget.image.hasMasks != null ? widget.image.hasMasks : false;
          },
        );
      }
    }
  }

  Future<List<ui.Image>> _loadImages(List<Mask> masks) async {
    List<ui.Image> images = [];
    for (var i = 0; i < masks.length; i++) {
      final ui.Image image = await loadUiImage(masks[i].asset);
      images.add(image);
    }
    return images;
  }

  Future<ui.Image> loadUiImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);
    return completer.future;
  }

  Widget _loadingIndicator() {
    return SizedBox(
      child: Center(
        child: CircularProgressIndicator(),
      ),
      width: widget.size,
    );
  }

  Widget _noImage() {
    return Hero(
      tag: widget.image.id,
      child: Transform.rotate(
        angle: _angle,
        child: Image.network(
          widget.isThumbnail
              ? 'https://via.placeholder.com/120x120.png?text=Image not available...'
              : 'https://via.placeholder.com/500x500.png?text=Image not available...',
          fit: BoxFit.cover,
          width: widget.size,
        ),
      ),
    );
  }

  Widget _loadedImage() {
    return Transform.rotate(
      angle: _angle,
      child: Container(
        alignment: Alignment(0, 0),
        width: widget.size,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              widget.isThumbnail
                  ? widget.image.downloadUrlTN
                  : widget.image.downloadUrl,
            ),
          ),
        ),
        child: FittedBox(
                fit: BoxFit.contain,
                child: _hasMasks ? CustomPaint(
                  size: Size(500, 500),
                  painter: FacePainter(_masks, _images),
                ) : SizedBox(width: 500, height: 500),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !_doneLoading
        ? _loadingIndicator()
        : _hasNoImage ? _noImage() : _loadedImage();
  }
}
