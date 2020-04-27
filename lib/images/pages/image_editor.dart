import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:selfiespel_mobile/images/widgets/image_face_painter.dart';
import 'dart:math' as math;
import '../../models/image.dart';

class ImageEditor extends StatefulWidget {
  final ImageRef image;
  ImageEditor(this.image);

  @override
  _ImageEditorState createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  File _imageFile;
  List<Face> _faces;
  bool _doneLoading = false;
  double _angle = 0;
  ui.Image _mask;
  bool _hasMasks = false;

  @override
  initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    final imageFile =
        await DefaultCacheManager().getSingleFile(widget.image.downloadUrl);
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
    if (mounted) {
      setState(
        () {
          _imageFile = imageFile;
          _doneLoading = true;
          _angle = angle;
        },
      );
    }
  }

  void _detectFaces(ui.Image selectedMask) async {
    final image = FirebaseVisionImage.fromFile(_imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
    final faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(
        () {
          _faces = faces;
          _mask = selectedMask;
        },
      );
    }
  }

  void _rotateImage() {
    setState(() {
      _angle = _angle + math.pi / 2;
    });
  }

  void _openMaskSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select mask'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/dog.png'),
                  ),
                  title: Text('Dog'),
                  trailing: IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () =>
                        Navigator.of(context).pop('assets/dog.png'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then(
      (result) => _selectMask(result),
    );
  }

  Future<ui.Image> loadUiImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);
    return completer.future;
  }

  void _selectMask(String selectedAsset) async {
    final image = await loadUiImage(selectedAsset);
    _detectFaces(image);
  }

  Widget _imageContainer() {
    return Transform.rotate(
      angle: _angle,
      child: Container(
          alignment: Alignment(0, 0),
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.image.downloadUrl),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CustomPaint(
              size: Size(500, 500),
              painter: FacePainter(_faces, _mask),
            ),
          )),
    );
  }

  Widget _displayImage(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: _imageContainer(),
        ),
        Flexible(
          flex: 1,
          child: ButtonBar(
            children: <Widget>[
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('ROTATE'),
                onPressed: () => _rotateImage(),
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('DETECT FACES'),
                onPressed: () => _openMaskSelector(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: _doneLoading
          ? _displayImage(context)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
