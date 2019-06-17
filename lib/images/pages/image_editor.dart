import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

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

  @override
  initState() {
    super.initState();
    _detectFaces();
  }

  void _detectFaces() async {
    print('detecting faces');
    final imageFile =
        await DefaultCacheManager().getSingleFile(widget.image.downloadUrl);
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
    final faces = await faceDetector.processImage(image);
    print(faces);
    if (mounted) {
      setState(
        () {
          _imageFile = imageFile;
          _faces = faces;
          _doneLoading = true;
        },
      );
    }
  }

  Widget _displayImagesAndFaces() {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Image.file(
              _imageFile,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: ListView(
            children: _faces.map<Widget>(
              (f) {
                final pos = f.boundingBox;
                return ListTile(
                  title: Text(
                      '(${pos.top},${pos.left}, ${pos.bottom}, ${pos.right})'),
                );
              },
            ).toList(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maskeer'),
      ),
      body: _doneLoading
          ? _displayImagesAndFaces()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
